import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_single_instance/flutter_single_instance.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

import 'data/data_sources/my_storage.dart';
import 'hidapi/hid.dart';
import 'provider/provider.dart';
import 'settings/key_store.dart' as key_store;
import 'ui/main_view.dart';

HID hid = HID(idVendor: 1148, idProduct: 22348);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Создаём только один экземпляр приложения
  if (!await FlutterSingleInstance.platform.isFirstInstance()) {
    exit(0);
  }

  await windowManager.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();
  // Извлекаем из хранилища положение окна на экране монитора
  final double? dx = sharedPreferences.getDouble(key_store.offsetX);
  final double? dy = sharedPreferences.getDouble(key_store.offsetY);
  // Извлекаем из хранилища значения микро шага, направления вращения и угла шага двигателя
  final microStep = sharedPreferences.getInt(key_store.microStep);
  final dir = sharedPreferences.getInt(key_store.dir);
  final stepAngle = sharedPreferences.getInt(key_store.stepAngle);
  // Извлекаем из хранилища значения регистра PSC и выбранное, min, max значения регистра ARR
  final psc = sharedPreferences.getInt(key_store.psc);
  final arrMin = sharedPreferences.getInt(key_store.arrMin);
  final arrMax = sharedPreferences.getInt(key_store.arrMax);
  final currentArr = sharedPreferences.getInt(key_store.currentArr);

  const initialSize = Size(590, 862);
  WindowOptions windowOptions = const WindowOptions(
    size: initialSize,
    minimumSize: initialSize,
    maximumSize: initialSize,
    skipTaskbar: false,
    title: 'Stepper motor test',
    // Скрыть панель с кнопками Windows
    titleBarStyle: TitleBarStyle.hidden,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    // Начальное положение окна
    if (dx == null || dy == null) {
      // Если пользователь не выбрал положение окна на экране монитора, размещаем по центру
      await windowManager.center();
    } else {
      await windowManager.setPosition(Offset(dx, dy));
    }
    // Размещаем приложение поверх других окон
    await windowManager.setAlwaysOnTop(true);
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(ProviderScope(
    overrides: [
      storageProvider.overrideWith((ref) => MyStorage(sharedPreferences)),
      microStepProvider.overrideWith((ref) => microStep ?? 0),
      directionProvider.overrideWith((ref) => dir ?? 0),
      stepAngleProvider.overrideWith((ref) => stepAngle ?? 0),
      pscProvider.overrideWith((ref) => psc ?? 0),
      currentArrProvider.overrideWith((ref) => currentArr ?? arrMin ?? 0),
      arrMinProvider.overrideWith((ref) => arrMin ?? 0),
      arrMaxProvider.overrideWith((ref) => arrMax ?? 65535),
    ],
    child: const MainView(),
  ));
}
