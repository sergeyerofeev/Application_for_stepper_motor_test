import 'dart:io';
import 'dart:typed_data';

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
late Uint8List rawData;

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

  const initialSize = Size(590, 840);
  WindowOptions windowOptions = const WindowOptions(
    size: initialSize,
    //minimumSize: initialSize,
    //maximumSize: initialSize,
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
    /*await windowManager.setAlwaysOnTop(true);
    await windowManager.show();
    await windowManager.focus();*/
  });

  runApp(ProviderScope(
    overrides: [
      storageProvider.overrideWithValue(MyStorage(sharedPreferences)),
    ],
    child: const MainView(),
  ));
}
