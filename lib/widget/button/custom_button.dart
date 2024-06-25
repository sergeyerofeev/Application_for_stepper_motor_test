import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stepper_motor_test/provider/provider.dart';
import 'button_global.dart' as button_g;

Widget singleRotation() => Consumer(
      builder: (_, ref, child) {
        final pscError = ref.watch(pscErrorProvider);
        final arrMinError = ref.watch(arrMinErrorProvider);
        final arrMaxError = ref.watch(arrMaxErrorProvider);
        return SizedBox(
          height: button_g.height,
          child: ElevatedButton(
            onPressed: (pscError == null && arrMinError == null && arrMaxError == null) ? () {} : null,
            child: child,
          ),
        );
      },
      child: button_g.buttonTitle(text: 'Один оборот'),
    );

Widget continuousRotation() => Consumer(
      builder: (_, ref, child) {
        final pscError = ref.watch(pscErrorProvider);
        final arrMinError = ref.watch(arrMinErrorProvider);
        final arrMaxError = ref.watch(arrMaxErrorProvider);
        return SizedBox(
          height: button_g.height,
          child: ElevatedButton(
            onPressed: (pscError == null && arrMinError == null && arrMaxError == null) ? () {} : null,
            child: child,
          ),
        );
      },
      child: button_g.buttonTitle(text: 'Непрерывное вращение'),
    );

Widget stopRotation() => Consumer(
      builder: (_, ref, child) => SizedBox(
        height: button_g.height,
        child: ElevatedButton(
          style: const ButtonStyle(
            side: MaterialStatePropertyAll(BorderSide(color: Color(0xFFFF0000), width: 2)),
          ),
          onPressed: () {},
          child: child,
        ),
      ),
      child: button_g.buttonTitle(textColor: const Color(0xFFFF0000), text: 'Стоп'),
    );
