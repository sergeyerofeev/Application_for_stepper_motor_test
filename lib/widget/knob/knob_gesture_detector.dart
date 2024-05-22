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
  late final double _minAngle;

  // Крайнее правое положение ручки регулятора в радианах
  late final double _maxAngle;

  // Предыдущее положение ручки регулятора  в радианах, начальное положение равно _minAngle
  late double _prevAngle;

  // Последнее известное положение ручки регулятора  в радианах, начальное положение равно _minAngle
  late double _finalAngle;

  // Направление поворота ручки регуляторо - по часовой
  bool _turnRight = true;

  // Направление поворота ручки регуляторо - против часовой
  bool _turnLeft = false;

  // Значение на которое поворачиваем указатель на ручке регулятора
  double _angleRotate = 2 / 3 * pi;

  // Центр виджета
  late Offset _centerOfGestureDetector;

  // Полная шкала между началом и концом шкалы
  late double _fullValue;

  @override
  void initState() {
    _minAngle = widget._startAngle / 180 * pi;
    _maxAngle = widget._endAngle / 180 * pi;
    _prevAngle = _finalAngle = _minAngle;
    _fullValue = widget._scaleMax - widget._scaleMin;
    super.initState();
  }

  _onPanUpdate(DragUpdateDetails details) {
    final touchPositionFromCenter = details.localPosition - _centerOfGestureDetector;
    // Текущее положение ручки регулятора в радианах
    final currentPos = touchPositionFromCenter.direction;
    // Блокируем перемещение от _minAngle до _maxAngle по нижней траектории
    if (currentPos <= _minAngle && currentPos >= _maxAngle) return;

    if ((currentPos <= _prevAngle + 0.1 && currentPos >= _prevAngle - 0.1) ||
        (currentPos >= -pi - 0.1 && currentPos <= -pi + 0.1) &&
            (_prevAngle >= pi - 0.1 && _prevAngle <= pi + 0.1) &&
            _turnRight ||
        (currentPos >= pi - 0.1 && currentPos <= pi + 0.1) &&
            (_prevAngle >= -pi - 0.1 && _prevAngle <= -pi + 0.1) &&
            _turnLeft) {
      if (_prevAngle < currentPos) {
        _turnRight = true;
        _turnLeft = false;
      } else if (_prevAngle > currentPos) {
        _turnRight = false;
        _turnLeft = true;
      }
      _prevAngle = currentPos;
      _finalAngle = currentPos;
      // Вычисляем угол поворота указателя на регуляторе
      if (currentPos >= pi * 2 / 3 && currentPos <= pi) {
        _angleRotate = currentPos;
        //debugPrint("${(_angleRotate * 57.3 - 120).round()}\n");
        final data = (((_angleRotate * 57.3 - widget._startAngle) * _fullValue / 300) * 100).truncateToDouble() / 100;
        ref.read(arrProvider.notifier).state = data;
      } else if (currentPos >= -pi && currentPos <= -0) {
        _angleRotate = _maxAngle + 5 / 3 * pi + currentPos;
        //debugPrint("${(_angleRotate * 57.3 - 120).round()}\n");
        final data = (((_angleRotate * 57.3 - widget._startAngle) * _fullValue / 300) * 100).truncateToDouble() / 100;
        ref.read(arrProvider.notifier).state = data;
      } else if (currentPos >= 0 && currentPos <= pi / 3) {
        _angleRotate = 2 * pi + currentPos;
        //debugPrint("${(_angleRotate * 57.3 - 120).round()}\n");
        final data = (((_angleRotate * 57.3 - widget._startAngle) * _fullValue / 300) * 100).truncateToDouble() / 100;
        ref.read(arrProvider.notifier).state = data;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _centerOfGestureDetector = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
        return GestureDetector(
          onPanUpdate: _onPanUpdate,
          child: Transform.rotate(
            angle: _finalAngle,
            // Указатель регулятора
            child: Container(
              alignment: Alignment.centerRight,
              child: Transform.rotate(
                angle: -_angleRotate,
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
}
