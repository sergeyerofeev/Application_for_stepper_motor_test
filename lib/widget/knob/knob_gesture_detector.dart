import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stepper_motor_test/provider/provider.dart';
import 'knob_indicator.dart';

/// Отслеживаем перемещение ручки регулятора с центром предоставленного виджета.
class KnobGestureDetector extends ConsumerStatefulWidget {
  // knobStartAngle и knobEndAngle отсчитываются от часовой стрелки расположенной на 3 часа
  // при движении по часовой.
  // Крайнее левое положение ручки регулятора в градусах
  final int _startAngle;

  // Крайнее правое положение ручки регулятора в градусах
  final int _endAngle;

  final double _scaleMin;
  final double _scaleMax;

  // Переменные для создания указателя на ручке регулятора
  late final double _indicatorWidth;
  late final double _indicatorHeight;
  late final ShapeBorder _indicatorShape;
  final EdgeInsets _indicatorMargin;
  final double _indicatorDepression;
  final List<Color> _shadowColors;

  KnobGestureDetector({
    super.key,
    required int knobStartAngle,
    required int knobEndAngle,
    required double scaleMin,
    required double scaleMax,
    required double indicatorDiameter,
    required EdgeInsets indicatorMargin,
    required double indicatorDepression,
    required List<Color> shadowColors,
  })  : _startAngle = knobStartAngle,
        _endAngle = knobEndAngle,
        _scaleMin = scaleMin,
        _scaleMax = scaleMax,
        _indicatorDepression = indicatorDepression,
        _indicatorMargin = indicatorMargin,
        _shadowColors = shadowColors {
    _indicatorWidth = indicatorDiameter;
    _indicatorHeight = indicatorDiameter;
    _indicatorShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(indicatorDiameter));
  }

  @override
  ConsumerState<KnobGestureDetector> createState() => _KnobGestureDetectorState();
}

class _KnobGestureDetectorState extends ConsumerState<KnobGestureDetector> {
  // Крайнее левое положение ручки регулятора в радианах
  late final double minAngle;

  // Крайнее правое положение ручки регулятора в радианах
  late final double maxAngle;

  late double currentPos;

  // Предыдущее положение ручки регулятора  в радианах, начальное положение равно _minAngle
  late double prevAngle;

  // Последнее известное положение ручки регулятора  в радианах, начальное положение равно _minAngle
  late double finalAngle;

  // Направление поворота ручки регуляторо - по часовой
  bool turnRight = true;

  // Направление поворота ручки регуляторо - против часовой
  bool turnLeft = false;

  // Значение на которое поворачиваем указатель на ручке регулятора
  double indicatorRotate = 2 / 3 * pi;

  // Центр виджета
  late Offset centerOfGestureDetector;

  // Полный диапазон по шкале регулятора между началом и концом шкалы
  late double fullValue;

  // Полный угол поворота регулятора в градусах от 0 до 360
  late int fullAngle;

  @override
  void initState() {
    minAngle = widget._startAngle / 180 * pi;
    maxAngle = widget._endAngle / 180 * pi;
    prevAngle = finalAngle = minAngle;
    fullValue = widget._scaleMax - widget._scaleMin;
    fullAngle = 360 - widget._startAngle + widget._endAngle;
    super.initState();
  }

  _onPanUpdate(DragUpdateDetails details) {
    final touchPositionFromCenter = details.localPosition - centerOfGestureDetector;
    // Текущее положение ручки регулятора в радианах
    currentPos = touchPositionFromCenter.direction;

    // Блокируем перемещение по нижней траектории от _minAngle до _maxAngle
    if (currentPos < minAngle && currentPos > maxAngle) return;

    if ((currentPos <= prevAngle + 0.1 && currentPos >= prevAngle - 0.1) ||
        (currentPos >= -pi - 0.1 && currentPos <= -pi + 0.1) &&
            (prevAngle >= pi - 0.1 && prevAngle <= pi + 0.1) &&
            turnRight ||
        (currentPos >= pi - 0.1 && currentPos <= pi + 0.1) &&
            (prevAngle >= -pi - 0.1 && prevAngle <= -pi + 0.1) &&
            turnLeft) {
      if (prevAngle < currentPos) {
        turnRight = true;
        turnLeft = false;
      } else if (prevAngle > currentPos) {
        turnRight = false;
        turnLeft = true;
      }
      prevAngle = currentPos;
      finalAngle = currentPos;

      // Вычисляем угол поворота указателя на регуляторе, а также значение на которое он указывает
      if (currentPos >= minAngle && currentPos <= pi) {
        indicatorRotate = currentPos;
        final data = (indicatorRotate * 180 / pi - widget._startAngle) * fullValue / fullAngle + widget._scaleMin;
        ref.read(arrProvider.notifier).state = data.round();
      } else {
        indicatorRotate = 2 * pi + currentPos;
        final data = (indicatorRotate * 180 / pi - widget._startAngle) * fullValue / fullAngle + widget._scaleMin;
        ref.read(arrProvider.notifier).state = data.round();
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(turnProvider, (previous, next) {
      if (next == 0) return;
      // Отслеживаем нажатие кнопок
      changeRotate(next);
      // Метод listen сработает только при изменении состояния, поэтому обнуляем
      ref.read(turnProvider.notifier).state = 0;
    });
    return LayoutBuilder(
      builder: (context, constraints) {
        centerOfGestureDetector = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
        return GestureDetector(
          onPanUpdate: _onPanUpdate,
          child: Transform.rotate(
            angle: finalAngle,
            // Указатель регулятора
            child: Container(
              alignment: Alignment.centerRight,
              child: Transform.rotate(
                angle: -indicatorRotate,
                // Указатель ручки регулятора, вращаем тень, вращение в обратную сторону
                child: Container(
                  // Размер указателя
                  width: widget._indicatorWidth,
                  height: widget._indicatorHeight,
                  margin: widget._indicatorMargin,
                  decoration: KnobIndicator(
                    indicatorShape: widget._indicatorShape,
                    indicatorDepression: widget._indicatorDepression,
                    shadowColors: [widget._shadowColors[0], Colors.white],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void changeRotate(int next) {
    switch (next) {
      case 11:
        // Переводим ручку регулятора в максимольное положение
        finalAngle = maxAngle;
        indicatorRotate = maxAngle;
      case -11:
        // Переводим ручку регулятора в минимальное положение
        finalAngle = minAngle;
        indicatorRotate = minAngle;
      default:
        // Если next положительно, поворот по часовой, отрицательно - против часовой
        final temp = fullAngle * pi / 180;
        finalAngle += temp / fullValue * next;
        indicatorRotate += temp / fullValue * next;
    }
    // Устанавливаем в переменные новые положения ручки регулятора, без этого
    // ручка станет недоступна для вращения касанием экрана
    if (finalAngle > pi) {
      // Переход через границу с +pi на -pi
      currentPos = finalAngle - 2 * pi;
      prevAngle = finalAngle - 2 * pi;
    } else {
      currentPos = finalAngle;
      prevAngle = finalAngle;
    }
  }
}
