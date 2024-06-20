import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/model.dart';
import '../../provider/provider.dart';

import 'knob_indicator.dart';
import 'knob_global.dart' as knob_g;

/// Отслеживаем перемещение ручки регулятора с центром предоставленного виджета
class KnobGestureDetector extends ConsumerStatefulWidget {
  const KnobGestureDetector({super.key});

  @override
  ConsumerState<KnobGestureDetector> createState() => _KnobGestureDetectorState();
}

class _KnobGestureDetectorState extends ConsumerState<KnobGestureDetector> {
  // Минимальное и максимальное значения регулятора
  late MinMaxValue _minMax;

  // Полный диапазон значений регулятора
  late int _fullValue;

  late double _currentPos;

  // Предыдущее положение ручки регулятора  в радианах, начальное положение равно _minAngleR
  double _prevAngleR = knob_g.startAngleR;

  // Последнее известное положение ручки регулятора  в радианах, начальное положение равно _minAngleR
  double _finalAngleR = knob_g.startAngleR;

  // Направление поворота ручки регуляторо - по часовой
  bool _turnRight = true;

  // Направление поворота ручки регуляторо - против часовой
  bool _turnLeft = false;

  // Значение на которое поворачиваем указатель на ручке регулятора
  double _indicatorRotate = 2 / 3 * pi;

  // Центр виджета
  late Offset _centerOfGestureDetector;

  @override
  Widget build(BuildContext context) {
    _minMax = ref.watch(minMaxProvider);

    _fullValue = _minMax.maxValue - _minMax.minValue;

    ref.listen<int>(buttonPressedProvider, (previous, next) {
      // Отслеживаем нажатие кнопок и изменяем положение ручки регулятора
      _setPosition(_minMax);
    });

    ref.listen<MinMaxValue>(minMaxProvider, (previous, next) {
      // Изменяем значение полного диапазона значений
      _fullValue = next.maxValue - next.minValue;
      // Устанавливаем ручку регулятора в нужное положение
      _setPosition(next);
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
                  width: knob_g.indicatorDiameter,
                  height: knob_g.indicatorDiameter,
                  margin: knob_g.indicatorMargin,
                  decoration: KnobIndicator(
                    indicatorShape: knob_g.indicatorShape,
                    indicatorDepression: knob_g.indicatorDepression,
                    shadowColors: [knob_g.shadowColors[0], Colors.white],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final touchPositionFromCenter = details.localPosition - _centerOfGestureDetector;
    // Текущее положение ручки регулятора в радианах
    _currentPos = touchPositionFromCenter.direction;

    // Блокируем перемещение по нижней траектории от _minAngle до _maxAngle
    if (_currentPos < knob_g.startAngleR && _currentPos > knob_g.endAngleR) return;

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
      if (_currentPos >= knob_g.startAngleR && _currentPos <= pi) {
        _indicatorRotate = _currentPos;
        final data =
            (_indicatorRotate * 180 / pi - knob_g.startAngle) * _fullValue / knob_g.fullAngle + _minMax.minValue;
        ref.read(currentArrProvider.notifier).state = data.round();
      } else {
        _indicatorRotate = 2 * pi + _currentPos;
        final data =
            (_indicatorRotate * 180 / pi - knob_g.startAngle) * _fullValue / knob_g.fullAngle + _minMax.minValue;
        ref.read(currentArrProvider.notifier).state = data.round();
      }
      // Обязательно запрашиваем перерисовку виджета
      setState(() {});
    }
  }

  void _setPosition(MinMaxValue next) {
    int currentValue = ref.read(currentArrProvider);

    if (currentValue < next.minValue) {
      // Изменение минимальной границы диапазона
      ref.read(currentArrProvider.notifier).state = next.minValue;
      currentValue = next.minValue;
    }
    if (currentValue > next.maxValue) {
      // Изменение максимальной границы диапазона
      ref.read(currentArrProvider.notifier).state = next.maxValue;
      currentValue = next.maxValue;
    }
    // Текущее значение регистра ARR не выходит за новые границы диапазона
    // Перемещаем указатель регулятора в соответствии с новыми границами
    _finalAngleR = knob_g.fullAngleR / _fullValue * (currentValue - next.minValue) + 2 * pi / 3;
    _indicatorRotate = _finalAngleR;

    if (_finalAngleR > pi) {
      _finalAngleR -= 2 * pi;
    }
    // Устанавливаем в переменные новые положения ручки регулятора
    _currentPos = _finalAngleR;
    _prevAngleR = _finalAngleR;

    // Обязательно запрашиваем перерисовку виджета
    setState(() {});
  }
}
