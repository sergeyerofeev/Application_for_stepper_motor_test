import 'package:flutter/material.dart';

import 'knob_gesture_detector.dart';
import 'knob_scale.dart';

class Knob extends StatelessWidget {
  // Общие
  final List<Color> _shadowColors;

  // Настройки ручки регулятора
  final double _knobWidth;
  final double _knobHeight;

  // knobStartAngle и knobEndAngle отсчитываются от часовой стрелки расположенной на 3 часа
  // при движении по часовой
  final int _knobStartAngle;
  final int _knobEndAngle;
  final Color _knobBackgroundColor;

  final Offset _knobShadowOffset;
  final double _knobShadowBlurRadius;
  final double _knobShadowSpreadRadius;

  // Настройки индикатора ручки регулятора
  final double _indicatorDiameter;
  final double _indicatorDepression;
  final EdgeInsets _indicatorMargin;

  // Настройка шкалы
  final double _scaleWidth;
  final double _scaleHeight;
  final double _scaleMin;
  final double _scaleMax;

  const Knob({
    super.key,
    double scaleDiameter = 420.0,
    double knobDiameter = 300.0,
    double indicatorDiameter = 40.0,
    int knobStartAngle = 120,
    int knobEndAngle = 60,
    Color knobBackgroundColor = Colors.grey,
    List<Color> shadowColors = const [Colors.black54, Colors.white],
    Offset knobShadowOffset = const Offset(1, 2),
    double knobShadowBlurRadius = 1.0,
    double knobShadowSpreadRadius = 3.0,
    double indicatorDepression = 4.0,
    EdgeInsets indicatorMargin = const EdgeInsets.all(10.0),
    double scaleMin = 0,
    double scaleMax = 300,
  })  : _scaleWidth = scaleDiameter,
        _scaleHeight = scaleDiameter,
        _knobWidth = knobDiameter,
        _knobHeight = knobDiameter,
        _indicatorDiameter = indicatorDiameter,
        _knobStartAngle = knobStartAngle,
        _knobEndAngle = knobEndAngle,
        _knobBackgroundColor = knobBackgroundColor,
        _shadowColors = shadowColors,
        _knobShadowOffset = knobShadowOffset,
        _knobShadowBlurRadius = knobShadowBlurRadius,
        _knobShadowSpreadRadius = knobShadowSpreadRadius,
        _indicatorDepression = indicatorDepression,
        _indicatorMargin = indicatorMargin,
        _scaleMin = scaleMin,
        _scaleMax = scaleMax;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        // Шкала регулятора
        Container(
          width: _scaleWidth,
          height: _scaleHeight,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
          ),
          child: RepaintBoundary(
            child: CustomPaint(
              size: Size(_scaleWidth, _scaleWidth),
              painter: KnobScale(
                scaleMin: _scaleMin,
                scaleMax: _scaleMax,
                scaleStartAngle: _knobStartAngle,
                scaleEndAngle: _knobEndAngle,
              ),
            ),
          ),
        ),
        // Ручка регулятора
        Container(
          width: _knobWidth,
          height: _knobHeight,
          decoration: BoxDecoration(
            color: _knobBackgroundColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _shadowColors[1],
                offset: -_knobShadowOffset,
                blurRadius: _knobShadowBlurRadius,
                spreadRadius: _knobShadowSpreadRadius,
              ),
              BoxShadow(
                color: _shadowColors[0],
                offset: _knobShadowOffset,
                blurRadius: _knobShadowBlurRadius,
                spreadRadius: _knobShadowSpreadRadius,
              ),
            ],
          ),
          margin: const EdgeInsets.all(30.0),
          child: KnobGestureDetector(
            knobStartAngle: _knobStartAngle,
            knobEndAngle: _knobEndAngle,
            indicatorDiameter: _indicatorDiameter,
            indicatorMargin: _indicatorMargin,
            indicatorDepression: _indicatorDepression,
            shadowColors: _shadowColors,
          ),
        ),
      ],
    );
  }
}
