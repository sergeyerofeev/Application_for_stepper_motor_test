import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stepper_motor_test/provider/provider.dart';
import 'button_global.dart' as button_g;

class ControlButtons extends ConsumerWidget {
  const ControlButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pscError = ref.watch(pscErrorProvider);
    final arrMinError = ref.watch(arrMinErrorProvider);
    final arrMaxError = ref.watch(arrMaxErrorProvider);
    final isRotation = ref.watch(rotationProvider);
    final isConnect = ref.watch(connectProvider);

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: button_g.height,
            child: ElevatedButton(
              onPressed: (isConnect && !isRotation && pscError == null && arrMinError == null && arrMaxError == null)
                  ? () {
                      // Устанавливаем флаг, чтобы сделать кнопки запуска не активными
                      ref.read(rotationProvider.notifier).state = true;
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
                  ? () {
                      // Устанавливаем флаг, чтобы сделать кнопки запуска не активными
                      ref.read(rotationProvider.notifier).state = true;
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
                  ? () {
                      ref.read(rotationProvider.notifier).state = false;
                    }
                  : null,
              child: button_g.buttonTitle(textColor: const Color(0xFFFF0000), text: 'Стоп'),
            ),
          ),
        ),
      ],
    );
  }
}
