import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stepper_motor_test/provider/provider.dart';

import '../../main.dart';
import 'button_global.dart' as button_g;

class ControlButtons extends ConsumerStatefulWidget {
  const ControlButtons({super.key});

  @override
  ConsumerState<ControlButtons> createState() => _ControlButtonsState();
}

class _ControlButtonsState extends ConsumerState<ControlButtons> {
  Timer? _timer;

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pscError = ref.watch(pscErrorProvider);
    final arrMinError = ref.watch(arrMinErrorProvider);
    final arrMaxError = ref.watch(arrMaxErrorProvider);
    final isRotation = ref.watch(rotationProvider);
    final isConnect = ref.watch(connectProvider);

    // Двигатель включен, передаём текущее значение для регистра ARR
    ref.listen(currentSendProvider, (previous, next) async {
      if (next != null) {
        if (_timer != null) {
          // Если таймер в данный момент работает, сбрасываем его
          _timer!.cancel();
        }

        _timer = Timer(const Duration(milliseconds: 100), () async {
          if (hid.open() == 0) {
            // Вычитаем 1 из значения для регистра ARR
            await hid.write(Uint8List.fromList([0, /*reportId = */ 2, next >> 8, next & 0xFF, ...List.filled(5, 0)]));
          }
          // По окончании выполнения callback функции устанавливаем _timer в null
          _timer = null;
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
      // Вычитаем 1 из значения для регистра PSC
      final pscReg = ref.read(pscProvider) - 1;
      data[3] = pscReg >> 8; // Загружаем старший байт для регистра PSC
      data[4] = pscReg & 0xFF; // Загружаем младший байт для регистра PSC
      // Вычитаем 1 из значения для регистра ARR
      final arrReg = ref.read(currentArrProvider) - 1;
      data[5] = arrReg >> 8; // Загружаем старший байт для регистра ARR
      data[6] = arrReg & 0xFF; // Загружаем младший байт для регистра ARR
      list = Uint8List.fromList([0, reportId, ...data]);
    }
    if (hid.open() == 0) {
      await hid.write(list);
    }
  }
}
