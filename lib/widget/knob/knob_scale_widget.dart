import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/provider.dart';
import 'knob_scale.dart';

class KnobScaleWidget extends ConsumerWidget {
  // Настройка шкалы
  final double _scaleWidth = 240;
  final double _scaleHeight = 330;
  final double _scaleMin = 0;
  final double _scaleFontSize = 18;

  final int _scaleStartAngle = 120;
  final int _scaleEndAngle = 60;

  const KnobScaleWidget({super.key});

/*  const KnobScaleWidget({
    super.key,
    required double scaleWidth,
    required double scaleHeight,
    required double scaleMin,
    required double scaleFontSize,
    required int scaleStartAngle,
    required int scaleEndAngle,
  })  : _scaleWidth = scaleWidth,
        _scaleHeight = scaleHeight,
        _scaleMin = scaleMin,
        _scaleFontSize = scaleFontSize,
        _scaleStartAngle = scaleStartAngle,
        _scaleEndAngle = scaleEndAngle;*/

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arrRegister = ref.watch(arrProvider);
    print('Repaint scale $arrRegister');
    return Container(
      width: _scaleWidth,
      height: _scaleHeight,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
      ),
      child: /*RepaintBoundary(
        child: */
          CustomPaint(
        size: Size(_scaleWidth, _scaleWidth),
        painter: KnobScale(
          scaleMin: _scaleMin,
          scaleMax: arrRegister.toDouble(),
          scaleStartAngle: _scaleStartAngle,
          scaleEndAngle: _scaleEndAngle,
          scaleFontSize: _scaleFontSize,
        ),
      ),
      //),
    );
  }
}
