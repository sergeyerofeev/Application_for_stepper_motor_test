import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/provider.dart';
import '../../settings/extension.dart';
import 'knob_gesture_detector.dart';
import 'knob_global.dart' as knob_g;
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
        const SizedBox(height: 25),
        Consumer(
          builder: (_, ref, __) {
            final sysclk = ref.watch(sysclkProvider).$1;
            final psc = ref.watch(pscProvider);
            final currentValue = ref.watch(currentArrProvider);
            final minMaxValue = ref.watch(minMaxProvider);
            final fullValue = minMaxValue.maxValue - minMaxValue.minValue;
            // Вычислим в зависимости от полного диапазона, на сколько будем перемещаться
            // по шкале при нажатии кнопок. Возвращаем меньший $1 и больший $2 шаг.
            final step = switch (fullValue) {
              > 10000 => (100, 1000),
              > 1000 => (10, 100),
              _ => (1, 10),
            };
            return SizedBox(
              // Строка кнопок для дискретного управления
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
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
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      const Text(
                        'Регистр ARR',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        SeparateIntWithSpaces(currentValue).priceString,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        color: Colors.blueGrey,
                        width: 150,
                        height: 2,
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Частота, Гц',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        SeparateDoubleWithSpaces(sysclk / psc / currentValue / 2).priceString,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
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
                  const Spacer(),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
