import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stepper_motor_test/provider/provider.dart';

import '../../main.dart';
import 'button_global.dart' as button_g;

class ControlButtons extends ConsumerWidget {
  static bool _flagSendData = true;

  const ControlButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pscError = ref.watch(pscErrorProvider);
    final arrMinError = ref.watch(arrMinErrorProvider);
    final arrMaxError = ref.watch(arrMaxErrorProvider);
    final isRotation = ref.watch(rotationProvider);
    final isConnect = ref.watch(connectProvider);

    ref.listen(currentSendProvider, (previous, next) async {
      if (_flagSendData && next != null && previous != null) {
        _flagSendData = false;
        await Future.delayed(const Duration(seconds: 10), () async {
          if (hid.open() == 0) {
            await hid.write(Uint8List.fromList([0, /*reportId = */ 2, next >> 8, next & 0xFF, ...List.filled(5, 0)]));
          }
          _flagSendData = true;
        });
      }
    });

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: button_g.height,
            child: ElevatedButton(
              onPressed: (isConnect && !isRotation && pscError == null && arrMinError == null && arrMaxError == null)
                  ? () async {
                      // Устанавливаем флаг, чтобы сделать кнопки запуска не активными
                      ref.read(rotationProvider.notifier).state = true;
                      // Отправляем данные
                      await _sendData(ref, 3);
                    }
                  : null,
              child: button_g.buttonTitle(text: 'Один оборот'),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: button_g.height,
            child: ElevatedButton(
              onPressed: (isConnect && !isRotation && pscError == null && arrMinError == null && arrMaxError == null)
                  ? () async {
                      // Устанавливаем флаг, чтобы сделать кнопки запуска не активными
                      ref.read(rotationProvider.notifier).state = true;
                      // Отправляем данные
                      await _sendData(ref, 4);
                    }
                  : null,
              child: button_g.buttonTitle(text: 'Непрерывное вращение'),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: button_g.height,
            child: ElevatedButton(
              style: const ButtonStyle(
                side: MaterialStatePropertyAll(BorderSide(color: Color(0xFFFF0000), width: 2)),
              ),
              onPressed: (isConnect)
                  ? () async {
                      // Делаем кнопки запуска активными
                      ref.read(rotationProvider.notifier).state = false;
                      // Отправляем данные
                      await _sendData(ref, 1);
                    }
                  : null,
              child: button_g.buttonTitle(textColor: const Color(0xFFFF0000), text: 'Стоп'),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _sendData(WidgetRef ref, int reportId) async {
    // Формируем и отправляем данные
    late final Uint8List list;
    if (reportId == 1) {
      // Команда на остановку двигателя
      list = Uint8List.fromList([0, reportId, ...List.filled(7, 0)]);
    } else {
      final List<int> data = List.filled(7, 0);
      // reportId = 3 - команда на один оборот, reportId = 4 - команда на непрерывное вращение
      data[0] = ref.read(microStepProvider);
      data[1] = ref.read(directionProvider);
      data[2] = ref.read(stepAngleProvider);
      final pscReg = ref.read(pscProvider);
      data[3] = pscReg >> 8; // Загружаем старший байт для регистра PSC
      data[4] = pscReg & 0xFF; // Загружаем младший байт для регистра PSC
      final arrReg = ref.read(currentArrProvider);
      data[5] = arrReg >> 8; // Загружаем старший байт для регистра ARR
      data[6] = arrReg & 0xFF; // Загружаем младший байт для регистра ARR
      list = Uint8List.fromList([0, reportId, ...data]);
    }
    if (hid.open() == 0) {
      await hid.write(list);
    }
  }
}
