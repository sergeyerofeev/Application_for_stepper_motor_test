import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stepper_motor_test/widget/button/control_buttons.dart';
import 'package:stepper_motor_test/widget/text_field/sysclk_field.dart';

import '../main.dart';
import '../provider/provider.dart';
import '../widget/knob/knob.dart';
import '../widget/popup_menu/direction_selection.dart';
import '../widget/popup_menu/micro_step_selection.dart';
import '../widget/popup_menu/step_angle_selection.dart';
import '../widget/text_field/arr_min_field.dart';
import '../widget/text_field/arr_max_field.dart';
import '../widget/text_field/psc_field.dart';

class MyContent extends ConsumerStatefulWidget {
  const MyContent({super.key});

  @override
  ConsumerState<MyContent> createState() => _MyContentState();
}

class _MyContentState extends ConsumerState<MyContent> {
  @override
  void initState() {
    Future(() => _hidOpen());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _hidOpen() {
    if (hid.open() != 0) {
      Timer.periodic(const Duration(seconds: 1), (timer) {
        if (hid.open() == 0) {
          // Установим статус поключения, true - связь с устройством установлена
          ref.read(connectProvider.notifier).state = true;
          timer.cancel();
          _hidRead();
        }
      });
    } else {
      // Ожидание установки соединенения не требуется
      // Установим статус поключения в true
      ref.read(connectProvider.notifier).state = true;
      _hidRead();
    }
  }

  void _hidRead() async {
    Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      try {
        final rawData = await hid.read(timeout: 10);
        // Если получили null, значит произошло отключение usb устройства
        if (rawData == null) throw Exception();
        if (rawData.isNotEmpty) {
          switch (rawData[0]) {
            case 5:
              // Оборот завершён, устанавливаем провайдер в false
              ref.read(rotationProvider.notifier).state = false;
            case 7:
              // Получили значение тактовой частоты
              final sysclkValue = rawData[1] << 24 | rawData[2] << 16 | rawData[3] << 8 | rawData[4];
              ref.read(sysclkProvider.notifier).state = (sysclkValue,);
          }
        }
      } catch (e) {
        // Устанавливаем статус подключения в false
        ref.read(connectProvider.notifier).state = false;
        timer.cancel();
        hid.close();
        _hidOpen();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(flex: 5, child: MicroStepSelection()),
                const SizedBox(width: 10),
                Expanded(flex: 5, child: DirectionSelection()),
                const SizedBox(width: 10),
                Expanded(flex: 4, child: StepAngleSelection()),
              ],
            ),
            const SizedBox(height: 40),
            const Row(
              children: [
                Expanded(child: SysClkField()),
                SizedBox(width: 10),
                Expanded(child: PscField()),
              ],
            ),
            const Row(
              children: [
                Expanded(child: ArrMinField()),
                SizedBox(width: 10),
                Expanded(child: ArrMaxField()),
              ],
            ),
            const SizedBox(height: 25),
            const Knob(),
            const SizedBox(height: 25),
            const ControlButtons(),
          ],
        ),
      ),
    );
  }
}
