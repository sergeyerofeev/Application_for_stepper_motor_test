import 'package:flutter/material.dart';
import 'dart:math';

class KnobScale extends CustomPainter {
  final double _startValue;
  final double _endValue;
  final int _startAngle;
  final int _endAngle;

  KnobScale({
    required double scaleMin,
    required double scaleMax,
    required int scaleStartAngle,
    required int scaleEndAngle,
  })  : _startValue = scaleMin,
        _endValue = scaleMax,
        _startAngle = scaleStartAngle,
        _endAngle = scaleEndAngle;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    // Полная шкала в градусах
    final fullScale = 360 - _startAngle + _endAngle;

    // Максимильное количество тиков на шкале
    const maxTick = 100;

    double valueTick = (_endValue - _startValue) / (1.0 * maxTick);

    for (int i = 0; i <= maxTick; i++) {
      final angle = (fullScale / maxTick * i + _startAngle) * pi / 180;

      if (i % 10 == 0) {
        // Рисуем длинные линии
        final start = Offset(center.dx + radius * cos(angle), center.dy + radius * sin(angle));
        final end = Offset(center.dx + 0.8 * radius * cos(angle), center.dy + 0.8 * radius * sin(angle));
        canvas.drawLine(start, end, paint);

        // Надписи над линиями
        final textPainter = TextPainter(
          text: TextSpan(
              text: '${_startValue + (valueTick * i)}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        final textOffset = Offset(
          center.dx + 1.22 * radius * cos(angle) - textPainter.width / 2,
          center.dy + 1.15 * radius * sin(angle) - textPainter.height / 2,
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
