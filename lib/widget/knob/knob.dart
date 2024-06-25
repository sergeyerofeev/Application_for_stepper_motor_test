import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'knob_global.dart' as knob_g;
import '../../provider/provider.dart';
import 'knob_gesture_detector.dart';
import 'knob_scale.dart';

class Knob extends ConsumerStatefulWidget {
  const Knob({super.key});

  @override
  ConsumerState<Knob> createState() => _KnobState();
}

class _KnobState extends ConsumerState<Knob> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            // Шкала регулятора
            Consumer(
              builder: (_, ref, __) {
                final minMaxValue = ref.watch(minMaxProvider);
                return CustomPaint(
                  size: const Size(knob_g.scaleDiameter, knob_g.scaleDiameter),
                  painter: KnobScale(
                    scaleMin: minMaxValue.minValue,
                    scaleMax: minMaxValue.maxValue,
                  ),
                );
              },
            ),
            // Ручка регулятора
            Container(
              width: knob_g.knobDiameter,
              height: knob_g.knobDiameter,
              decoration: BoxDecoration(
                color: knob_g.knobBackgroundColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: knob_g.shadowColors[1],
                    offset: -knob_g.knobShadowOffset,
                    blurRadius: knob_g.knobShadowBlurRadius,
                    spreadRadius: knob_g.knobShadowSpreadRadius,
                  ),
                  BoxShadow(
                    color: knob_g.shadowColors[0],
                    offset: knob_g.knobShadowOffset,
                    blurRadius: knob_g.knobShadowBlurRadius,
                    spreadRadius: knob_g.knobShadowSpreadRadius,
                  ),
                ],
              ),
              margin: const EdgeInsets.all(30.0),
              child: const KnobGestureDetector(),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Consumer(
          builder: (_, ref, __) {
            final currentValue = ref.watch(currentArrProvider);
            final minMaxValue = ref.watch(minMaxProvider);
            final fullValue = minMaxValue.maxValue - minMaxValue.minValue;
            final step = knob_g.calcJamp(fullValue);
            return SizedBox(
              // Ширину строки кнопок выбираем по размеру диаметра шкалы регулятора добавив 50 px
              width: knob_g.scaleDiameter + 50,
              // Строка кнопок для дискретного управления
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: (currentValue > minMaxValue.minValue)
                        ? () {
                            if (currentValue - step.$1 < minMaxValue.minValue) {
                              ref.read(currentArrProvider.notifier).state = minMaxValue.minValue;
                            } else {
                              ref.read(currentArrProvider.notifier).update((state) => state - step.$1);
                            }
                            // Просто изменяем state, чтобы вызвать listen()
                            ref.read(buttonPressedProvider.notifier).state--;
                          }
                        : null,
                    child: Text('-${step.$1}'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: (currentValue > minMaxValue.minValue && fullValue > step.$2)
                        ? () {
                            if (currentValue - step.$2 < minMaxValue.minValue) {
                              ref.read(currentArrProvider.notifier).state = minMaxValue.minValue;
                            } else {
                              ref.read(currentArrProvider.notifier).update((state) => state - step.$2);
                            }
                            ref.read(buttonPressedProvider.notifier).state--;
                          }
                        : null,
                    child: Text('-${step.$2}'),
                  ),
                  const Spacer(),
                  Text(
                    currentValue.toString(),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: (currentValue < minMaxValue.maxValue && fullValue > step.$2)
                        ? () {
                            if (currentValue + step.$2 > minMaxValue.maxValue) {
                              ref.read(currentArrProvider.notifier).state = minMaxValue.maxValue;
                            } else {
                              ref.read(currentArrProvider.notifier).update((state) => state + step.$2);
                            }
                            ref.read(buttonPressedProvider.notifier).state++;
                          }
                        : null,
                    child: Text('+${step.$2}'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: (currentValue < minMaxValue.maxValue)
                        ? () {
                            if (currentValue + step.$1 > minMaxValue.maxValue) {
                              ref.read(currentArrProvider.notifier).state = minMaxValue.maxValue;
                            } else {
                              ref.read(currentArrProvider.notifier).update((state) => state + step.$1);
                            }
                            ref.read(buttonPressedProvider.notifier).state++;
                          }
                        : null,
                    child: Text('+${step.$1}'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
