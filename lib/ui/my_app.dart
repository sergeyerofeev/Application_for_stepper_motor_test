import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stepper_motor_test/widget/text_field/arr_field.dart';
import 'package:stepper_motor_test/widget/text_field/psc_field.dart';

import '../main.dart';
import '../provider/provider.dart';
import '../widget/draggeble_app_bar.dart';
import '../widget/knob/knob.dart';
import '../widget/popup_menu/micro_step_selection.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late final Timer hidTimer;

/*  PopupMenu? menu;
  GlobalKey btnKey = GlobalKey();*/

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: const MaterialStatePropertyAll<Color>(Colors.white),
            //foregroundColor: const MaterialStatePropertyAll<Color>(Colors.black),
            surfaceTintColor: const MaterialStatePropertyAll<Color>(Colors.white),
            padding: MaterialStateProperty.all(const EdgeInsets.all(10.0)),
            side: MaterialStateProperty.all(const BorderSide(color: Colors.grey, width: 2)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
            overlayColor: MaterialStateProperty.resolveWith(
              (states) {
                return states.contains(MaterialState.pressed) ? Colors.grey : Colors.white;
              },
            ),
          ),
        ),
      ),
      home: DecoratedBox(
        decoration: const BoxDecoration(
          color: Color(0xFFFEFEFE),
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const DraggebleAppBar(),
          body: SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MicroStepSelection(),
                      const SizedBox(height: 30),
                      const PrescalerField(),
                      //const SizedBox(height: 30),
                      const AutoReloadField(),
                      //const SizedBox(height: 30),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Knob(
                  knobDiameter: 240,
                  scaleDiameter: 330,
                  scaleMin: 20,
                  scaleMax: 330,
                  indicatorDiameter: 35,
                  scaleFontSize: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
