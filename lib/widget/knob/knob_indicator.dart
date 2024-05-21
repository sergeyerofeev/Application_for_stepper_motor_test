import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class KnobIndicator extends Decoration {
  final ShapeBorder _shape;
  final double _depression;
  final List<Color> _shadowColors;

  const KnobIndicator({
    required ShapeBorder indicatorShape,
    required double indicatorDepression,
    required List<Color> shadowColors,
  })  : _shape = indicatorShape,
        _depression = indicatorDepression,
        _shadowColors = shadowColors;

  @override
  BoxPainter createBoxPainter([ui.VoidCallback? onChanged]) => _KnobIndicatorPainter(
        shape: _shape,
        indicatorDepression: _depression,
        shadowColors: _shadowColors,
      );

  @override
  EdgeInsetsGeometry get padding => _shape.dimensions;
}

// Рисуем индикатор
class _KnobIndicatorPainter extends BoxPainter {
  final ShapeBorder _shape;
  final double _indicatorDepression;
  final List<Color> _shadowColors;

  const _KnobIndicatorPainter({
    required ShapeBorder shape,
    required double indicatorDepression,
    required List<Color> shadowColors,
  })  : _shape = shape,
        _indicatorDepression = indicatorDepression,
        _shadowColors = shadowColors;

  @override
  void paint(ui.Canvas canvas, ui.Offset offset, ImageConfiguration configuration) {
    final rect = offset & configuration.size!;
    final shapePath = _shape.getOuterPath(rect);

    final delta = 16 / rect.longestSide;
    final stops = [0.5 - delta, 0.5 + delta];

    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(rect.inflate(_indicatorDepression * 2))
      ..addPath(shapePath, Offset.zero);
    canvas.save();
    canvas.clipPath(shapePath);

    final paint = Paint()..maskFilter = MaskFilter.blur(BlurStyle.normal, _indicatorDepression);
    final clipSize = rect.size.aspectRatio > 1 ? Size(rect.width, rect.height / 2) : Size(rect.width / 2, rect.height);
    for (final alignment in [Alignment.topLeft, Alignment.bottomRight]) {
      final shaderRect = alignment.inscribe(Size.square(rect.longestSide), rect);
      paint.shader = ui.Gradient.linear(shaderRect.topLeft, shaderRect.bottomRight, _shadowColors, stops);

      canvas.save();
      canvas.clipRect(alignment.inscribe(clipSize, rect));
      canvas.drawPath(path, paint);
      canvas.restore();
    }
    canvas.restore();
  }
}
