import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../provider/provider.dart';
import '../widget/draggeble_app_bar.dart';
import '../widget/knob/knob.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
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
    final arrValue = ref.watch(arrProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: const MaterialStatePropertyAll<Color>(Colors.white),
/*            foregroundColor: const MaterialStatePropertyAll<Color>(Colors.black),*/
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
        decoration: BoxDecoration(
          color: Color(0xFFFEFEFE),
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: DraggebleAppBar(),
          body: SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Knob(
                  knobDiameter: 240,
                  scaleDiameter: 330,
                  indicatorDiameter: 35,
                  scaleFontSize: 18,
                ),
                SizedBox(height: 20),
                Container(
                  width: 380,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed:
                            (arrValue > 0) ? () => ref.read(arrProvider.notifier).update((state) => state - 1) : null,
                        child: const Text('-1'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed:
                            (arrValue > 0) ? () => ref.read(arrProvider.notifier).update((state) => state - 10) : null,
                        child: const Text('-10'),
                      ),
                      Spacer(),
                      Text('$arrValue'),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () => ref.read(arrProvider.notifier).update((state) => state + 10),
                        child: const Text('+10'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => ref.read(arrProvider.notifier).update((state) => state + 1),
                        child: const Text('+1'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
