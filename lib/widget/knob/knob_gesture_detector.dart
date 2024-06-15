import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stepper_motor_test/provider/provider.dart';
import 'knob_indicator.dart';

/// Отслеживаем перемещение ручки регулятора с центром предоставленного виджета.
class KnobGestureDetector extends ConsumerStatefulWidget {
  // knobStartAngle и knobEndAngle отсчитываются от часовой стрелки расположенной на 3 часа
  // при движении по часовой.
  // Крайнее левое положение ручки регулятора в градусах и радианах
  final int _startAngle;
  late final double _startAngleR;
  // Крайнее правое положение ручки регулятора в градусах и радианах
  final int _endAngle;
  late final double _endAngleR;

  final double _scaleMin;
  final double _scaleMax;

  // Полный диапазон по шкале регулятора между началом и концом шкалы
  late final double _fullValue;

  // Полный угол поворота регулятора в градусах от 0 до 360
  late final int _fullAngle;

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
    _startAngleR = _startAngle / 180.0 * pi;
    _endAngleR = _endAngle / 180.0 * pi;
    _fullValue = _scaleMax - _scaleMin;
    _fullAngle = 360 - _startAngle + _endAngle;
    _indicatorWidth = indicatorDiameter;
    _indicatorHeight = indicatorDiameter;
    _indicatorShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(indicatorDiameter));
  }

  @override
  ConsumerState<KnobGestureDetector> createState() => _KnobGestureDetectorState();
}

class _KnobGestureDetectorState extends ConsumerState<KnobGestureDetector> {
  late double _currentPos;

  // Предыдущее положение ручки регулятора  в радианах, начальное положение равно _minAngleR
  late double _prevAngleR;

  // Последнее известное положение ручки регулятора  в радианах, начальное положение равно _minAngleR
  late double _finalAngleR;

  // Направление поворота ручки регуляторо - по часовой
  bool _turnRight = true;

  // Направление поворота ручки регуляторо - против часовой
  bool _turnLeft = false;

  // Значение на которое поворачиваем указатель на ручке регулятора
  double _indicatorRotate = 2 / 3 * pi;

  // Центр виджета
  late Offset _centerOfGestureDetector;

  @override
  void initState() {
    super.initState();
    _prevAngleR = _finalAngleR = widget._startAngleR;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(turnProvider, (previous, next) {
      if (next == 0) return;
      // Отслеживаем нажатие кнопок и изменяем положение ручки регулятора
      _changeRotate(next);
      // Метод listen сработает только при изменении состояния, поэтому необходимо обнулить
      ref.read(turnProvider.notifier).state = 0;
    });
    return LayoutBuilder(
      builder: (context, constraints) {
        _centerOfGestureDetector = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
        return GestureDetector(
          onPanUpdate: _onPanUpdate,
          child: Transform.rotate(
            angle: _finalAngleR,
            // Указатель регулятора
            child: Container(
              alignment: Alignment.centerRight,
              child: Transform.rotate(
                angle: -_indicatorRotate,
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

  _onPanUpdate(DragUpdateDetails details) {
    final touchPositionFromCenter = details.localPosition - _centerOfGestureDetector;
    // Текущее положение ручки регулятора в радианах
    _currentPos = touchPositionFromCenter.direction;

    // Блокируем перемещение по нижней траектории от _minAngle до _maxAngle
    if (_currentPos < widget._startAngleR && _currentPos > widget._endAngleR) return;

    if ((_currentPos <= _prevAngleR + 0.1 && _currentPos >= _prevAngleR - 0.1) ||
        (_currentPos >= -pi - 0.1 && _currentPos <= -pi + 0.1) &&
            (_prevAngleR >= pi - 0.1 && _prevAngleR <= pi + 0.1) &&
            _turnRight ||
        (_currentPos >= pi - 0.1 && _currentPos <= pi + 0.1) &&
            (_prevAngleR >= -pi - 0.1 && _prevAngleR <= -pi + 0.1) &&
            _turnLeft) {
      if (_prevAngleR < _currentPos) {
        _turnRight = true;
        _turnLeft = false;
      } else if (_prevAngleR > _currentPos) {
        _turnRight = false;
        _turnLeft = true;
      }
      _prevAngleR = _currentPos;
      _finalAngleR = _currentPos;

      // Вычисляем угол поворота указателя на регуляторе, а также значение на которое он указывает
      if (_currentPos >= widget._startAngleR && _currentPos <= pi) {
        _indicatorRotate = _currentPos;
        final data = (_indicatorRotate * 180 / pi - widget._startAngle) * widget._fullValue / widget._fullAngle +
            widget._scaleMin;
        ref.read(currentArrProvider.notifier).state = data.round();
      } else {
        _indicatorRotate = 2 * pi + _currentPos;
        final data = (_indicatorRotate * 180 / pi - widget._startAngle) * widget._fullValue / widget._fullAngle +
            widget._scaleMin;
        ref.read(currentArrProvider.notifier).state = data.round();
      }
    }
  }

  void _changeRotate(int next) {
    switch (next) {
      case 11:
        // Переводим ручку регулятора в максимольное положение
        _finalAngleR = widget._endAngleR;
        _indicatorRotate = widget._endAngleR;
      case -11:
        // Переводим ручку регулятора в минимальное положение
        _finalAngleR = widget._startAngleR;
        _indicatorRotate = widget._startAngleR;
      default:
        // Если next положительно, поворот по часовой, отрицательно - против часовой
        final temp = widget._fullAngle * pi / 180;
        _finalAngleR += temp / widget._fullValue * next;
        _indicatorRotate += temp / widget._fullValue * next;
    }
    // Устанавливаем в переменные новые положения ручки регулятора, без этого
    // ручка станет недоступна для вращения касанием экрана
    if (_finalAngleR > pi) {
      // Переход через границу с +pi на -pi
      _currentPos = _finalAngleR - 2 * pi;
      _prevAngleR = _finalAngleR - 2 * pi;
    } else {
      _currentPos = _finalAngleR;
      _prevAngleR = _finalAngleR;
    }
  }
}
