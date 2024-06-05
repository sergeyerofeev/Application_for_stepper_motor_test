import 'package:flutter/material.dart';

import 'menu_config.dart';

class TrianglePainter extends CustomPainter {
  final bool _isDown;

  // Цвет рисуемого треугольника, совпадает с цветом фона элемента выпадающего меню
  final Color _color;
  final BorderConfig _border;

  const TrianglePainter({
    required bool isDown,
    required Color color,
    required BorderConfig border,
  })  : _isDown = isDown,
        _color = color,
        _border = border;

  @override
  void paint(Canvas canvas, Size size) {
    // Рисуем треугольник c цветом фона элемента всплывающего меню
    Paint paint = Paint();
    paint.color = _color;
    paint.style = PaintingStyle.fill;

    Path path = Path();
    if (_isDown) {
      path.moveTo(0.0, _border.width * -1);
      path.lineTo(size.width, _border.width * -1);
      path.lineTo(size.width / 2.0, size.height);
    } else {
      path.moveTo(size.width / 2.0, 0);
      path.lineTo(0.0, size.height + _border.width);
      path.lineTo(size.width, size.height + _border.width);
    }

    canvas.drawPath(path, paint);

    if (_border.width != 0) {
      // Рисуем бордюр вокруг треугольника
      Paint trianglePaint = Paint();
      trianglePaint.strokeWidth = _border.width;
      trianglePaint.strokeCap = StrokeCap.round;
      trianglePaint.color = _border.color;
      trianglePaint.style = PaintingStyle.stroke;

      Path path2 = Path();
      if (_isDown) {
        path2.moveTo(0.0, _border.width * -0.05);
        path2.lineTo(size.width / 2.0, size.height);
        path2.moveTo(size.width, _border.width * -0.05);
        path2.lineTo(size.width / 2.0, size.height);
      } else {
        path2.moveTo(size.width / 2.0, 0.0);
        path2.lineTo(0.0, size.height);
        path2.moveTo(size.width / 2.0, 0.0);
        path2.lineTo(size.width, size.height);
      }

      canvas.drawPath(path2, trianglePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
