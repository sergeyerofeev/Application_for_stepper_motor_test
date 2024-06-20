import 'package:flutter/material.dart';
import 'dart:math';
import 'knob_global.dart' as knob_g;

class KnobScale extends CustomPainter {
  final int _scaleMin;
  final int _scaleMax;

  KnobScale({
    required int scaleMin,
    required int scaleMax,
  })  : _scaleMin = scaleMin,
        _scaleMax = scaleMax;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = knob_g.scaleColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    // Максимильное количество тиков на шкале
    const maxTick = 100;
    // Величина для одного деления шкалы
    double valueTick = (_scaleMax - _scaleMin) / (1.0 * maxTick);
    // Количество цифр после запятой при выводе числа на шкалу
    final fractionDigits = (valueTick < 0.1) ? 1 : 0;
    for (int i = 0; i <= maxTick; i++) {
      final angle = (knob_g.fullAngle / maxTick * i + knob_g.startAngle) * pi / 180;

      if (i % 10 == 0) {
        // Рисуем длинные линии
        final start = Offset(center.dx + radius * cos(angle), center.dy + radius * sin(angle));
        final end = Offset(center.dx + 0.8 * radius * cos(angle), center.dy + 0.8 * radius * sin(angle));
        canvas.drawLine(start, end, paint);

        // Надписи над линиями
        final textPainter = TextPainter(
          text: TextSpan(
              text: (_scaleMin + (valueTick * i)).toStringAsFixed(fractionDigits).replaceFirst('.', ','),
              style: const TextStyle(
                color: knob_g.scaleColor,
                fontSize: knob_g.scaleFontSize,
                fontWeight: FontWeight.bold,
              )),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        // Расчитываем коэффициент смещения цифр по горизонтали
        final kdx = (_scaleMax >= 12500)
            ? 1.22
            : (_scaleMax >= 1250)
                ? 1.185
                : 1.16;
        final textOffset = Offset(
          center.dx + kdx * radius * cos(angle) - textPainter.width / 2,
          center.dy + 1.11 * radius * sin(angle) - textPainter.height / 2,
        );
        textPainter.paint(canvas, textOffset);
      } else if (i % 5 == 0) {
        // Рисуем половинные линии
        final start = Offset(center.dx + 0.95 * radius * cos(angle), center.dy + 0.95 * radius * sin(angle));
        final end = Offset(center.dx + 0.8 * radius * cos(angle), center.dy + 0.8 * radius * sin(angle));
        canvas.drawLine(start, end, paint);
      } else {
        // Рисуем короткие линии
        final start = Offset(center.dx + 0.9 * radius * cos(angle), center.dy + 0.9 * radius * sin(angle));
        final end = Offset(center.dx + 0.8 * radius * cos(angle), center.dy + 0.8 * radius * sin(angle));
        canvas.drawLine(start, end, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
