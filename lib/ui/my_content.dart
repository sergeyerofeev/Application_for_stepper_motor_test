import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widget/popup_menu/direction_selection.dart';
import '../widget/popup_menu/step_angle_selection.dart';
import '../widget/text_field/arr_field.dart';
import '../widget/text_field/psc_field.dart';
import '../main.dart';
import '../provider/provider.dart';
import '../widget/knob/knob.dart';
import '../widget/popup_menu/micro_step_selection.dart';

class MyContent extends ConsumerStatefulWidget {
  const MyContent({super.key});

  @override
  ConsumerState<MyContent> createState() => _MyContentState();
}

class _MyContentState extends ConsumerState<MyContent> {
  late final Timer hidTimer;

  @override
  void initState() {
    Future(() {
      hidTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        // Выполнив функцию hid.open(), при подключенном устройстве, обмен разрешается
        int hidConnect = hid.open();
        bool hidStatus = ref.read(hidProvider);
        if (hidConnect == 0 && !hidStatus) {
          // Установим статус поключения, true - связь с устройством установлена
          ref.read(hidProvider.notifier).update((_) => true);
        } else if (hidConnect != 0 && hidStatus) {
          // В случае разрыва связи, закрываем текущий hid
          hid.close();
          // Устанавливаем статус в false
          ref.read(hidProvider.notifier).update((_) => false);
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    hidTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arrRegister = ref.watch(arrProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /*Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(flex: 5, child: MicroStepSelection()),
                const SizedBox(width: 20),
                Expanded(flex: 5, child: DirectionSelection()),
                const SizedBox(width: 20),
                Expanded(flex: 4, child: StepAngleSelection()),
              ],
            ),
            const SizedBox(height: 40),
            const PrescalerField(),
            const AutoReloadField(),
            const SizedBox(height: 20),*/

            const AutoReloadField(),
            const SizedBox(height: 20),
            Knob(
              knobDiameter: 240,
              scaleDiameter: 330,
              scaleMin: 0,
              scaleMax: arrRegister.toDouble(),
              indicatorDiameter: 35,
              scaleFontSize: 18,
            ),
          ],
        ),
      ),
    );
  }
}
