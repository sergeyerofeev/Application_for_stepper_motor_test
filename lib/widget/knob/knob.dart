import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stepper_motor_test/widget/knob/knob_scale_widget.dart';

import '../../provider/provider.dart';
import 'knob_gesture_detector.dart';
import 'knob_scale.dart';

class Knob extends ConsumerStatefulWidget {
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
  final double _scaleFontSize;

  const Knob({
    super.key,
    double scaleDiameter = 420.0,
    double knobDiameter = 300.0,
    double indicatorDiameter = 40.0,
    int knobStartAngle = 120,
    int knobEndAngle = 60,
    Color knobBackgroundColor = Colors.grey,
    List<Color> shadowColors = const [Colors.black54, Colors.black26],
    Offset knobShadowOffset = const Offset(2, 2),
    double knobShadowBlurRadius = 1.0,
    double knobShadowSpreadRadius = 3.0,
    double indicatorDepression = 4.0,
    EdgeInsets indicatorMargin = const EdgeInsets.all(10.0),
    double scaleMin = 0,
    double scaleMax = 300.0,
    double scaleFontSize = 16,
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
        _scaleMax = scaleMax,
        _scaleFontSize = scaleFontSize;

  @override
  ConsumerState<Knob> createState() => _KnobState();
}

class _KnobState extends ConsumerState<Knob> {
  @override
  void initState() {
    Future(() {
      ref.read(currentArrProvider.notifier).state = widget._scaleMin.toInt();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentValue = ref.watch(currentArrProvider);
    final fullScale = widget._scaleMax - widget._scaleMin;
    print('ребилд knob');
    return Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            const KnobScaleWidget(),
            /*KnobScaleWidget(
              scaleWidth: widget._scaleWidth,
              scaleHeight: widget._scaleHeight,
              scaleMin: widget._scaleMin,
              scaleStartAngle: widget._knobStartAngle,
              scaleEndAngle: widget._knobEndAngle,
              scaleFontSize: widget._scaleFontSize,
            ),*/
            // Шкала регулятора
            /*Container(
              width: widget._scaleWidth,
              height: widget._scaleHeight,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: RepaintBoundary(
                child: CustomPaint(
                  size: Size(widget._scaleWidth, widget._scaleWidth),
                  painter: KnobScale(
                    scaleMin: widget._scaleMin,
                    scaleMax: widget._scaleMax,
                    scaleStartAngle: widget._knobStartAngle,
                    scaleEndAngle: widget._knobEndAngle,
                    scaleFontSize: widget._scaleFontSize,
                  ),
                ),
              ),
            ),*/
            // Ручка регулятора
            Container(
              width: widget._knobWidth,
              height: widget._knobHeight,
              decoration: BoxDecoration(
                color: widget._knobBackgroundColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget._shadowColors[1],
                    offset: -widget._knobShadowOffset,
                    blurRadius: widget._knobShadowBlurRadius,
                    spreadRadius: widget._knobShadowSpreadRadius,
                  ),
                  BoxShadow(
                    color: widget._shadowColors[0],
                    offset: widget._knobShadowOffset,
                    blurRadius: widget._knobShadowBlurRadius,
                    spreadRadius: widget._knobShadowSpreadRadius,
                  ),
                ],
              ),
              margin: const EdgeInsets.all(30.0),
              child: KnobGestureDetector(
                knobStartAngle: widget._knobStartAngle,
                knobEndAngle: widget._knobEndAngle,
                scaleMin: widget._scaleMin,
                scaleMax: widget._scaleMax,
                indicatorDiameter: widget._indicatorDiameter,
                indicatorMargin: widget._indicatorMargin,
                indicatorDepression: widget._indicatorDepression,
                shadowColors: widget._shadowColors,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        /*SizedBox(
          // Ширину строки кнопок выбираем по размеру диаметра шкалы регулятора добавив 50 px
          width: widget._scaleWidth + 50,
          // Строка кнопок для дискретного управления
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: (currentValue > widget._scaleMin)
                    ? () {
                        if (currentValue - 1 < widget._scaleMin) {
                          ref.read(currentArrProvider.notifier).state = widget._scaleMin.toInt();
                          ref.read(turnProvider.notifier).state = -11;
                        } else {
                          ref.read(currentArrProvider.notifier).update((state) => state - 1);
                          ref.read(turnProvider.notifier).state = -1;
                        }
                      }
                    : null,
                child: const Text('-1'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: (currentValue > widget._scaleMin && fullScale > 10)
                    ? () {
                        if (currentValue - 10 < widget._scaleMin) {
                          ref.read(currentArrProvider.notifier).state = widget._scaleMin.toInt();
                          ref.read(turnProvider.notifier).state = -11;
                        } else {
                          ref.read(currentArrProvider.notifier).update((state) => state - 10);
                          ref.read(turnProvider.notifier).state = -10;
                        }
                      }
                    : null,
                child: const Text('-10'),
              ),
              const Spacer(),
              Text(
                currentValue.round().toString(),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: (currentValue < widget._scaleMax && fullScale > 10)
                    ? () {
                        if (currentValue + 10 > widget._scaleMax) {
                          ref.read(currentArrProvider.notifier).state = widget._scaleMax.toInt();
                          ref.read(turnProvider.notifier).state = 11;
                        } else {
                          ref.read(currentArrProvider.notifier).update((state) => state + 10);
                          ref.read(turnProvider.notifier).state = 10;
                        }
                      }
                    : null,
                child: const Text('+10'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: (currentValue < widget._scaleMax)
                    ? () {
                        if (currentValue + 1 > widget._scaleMax) {
                          ref.read(currentArrProvider.notifier).state = widget._scaleMax.toInt();
                          ref.read(turnProvider.notifier).state = 11;
                        } else {
                          ref.read(currentArrProvider.notifier).update((state) => state + 1);
                          ref.read(turnProvider.notifier).state = 1;
                        }
                      }
                    : null,
                child: const Text('+1'),
              ),
            ],
          ),
        ),*/
      ],
    );
  }
}
