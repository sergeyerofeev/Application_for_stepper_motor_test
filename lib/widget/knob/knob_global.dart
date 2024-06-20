import 'dart:math';

import 'package:flutter/material.dart';

// Настройка ручки регулятора
const double knobDiameter = 240.0;
// startAngle и endAngle отсчитываются от часовой стрелки расположенной на 3 часа
// при движении по часовой.
// Крайнее левое положение ручки регулятора в градусах и радианах
const int startAngle = 120;
const double startAngleR = startAngle / 180.0 * pi;
// Крайнее правое положение ручки регулятора в градусах и радианах
const int endAngle = 60;
const double endAngleR = endAngle / 180.0 * pi;
// Полный диапазон шкалы в градусах и радианах
const int fullAngle = 360 - startAngle + endAngle;
const double fullAngleR = fullAngle / 180.0 * pi;
// Настройки стиля ручки регулятора
const Color knobBackgroundColor = Colors.grey;
const List<Color> shadowColors = [Colors.black54, Colors.black26];
const Offset knobShadowOffset = Offset(2, 2);
const double knobShadowBlurRadius = 1.0;
const double knobShadowSpreadRadius = 3.0;

// Глобальные переменные для шкалы регулятора
const double scaleDiameter = 330.0;
const double scaleFontSize = 18.0;
const Color scaleColor = Colors.grey;

// Настройка круглого индикатора на ручке регулятора
const double indicatorDiameter = 40.0;
const double indicatorDepression = 4.0;
const EdgeInsets indicatorMargin = EdgeInsets.all(10.0);
final ShapeBorder indicatorShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(indicatorDiameter));
