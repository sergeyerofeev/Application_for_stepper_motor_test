import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/data_sources/i_data_base.dart';

// Провайдер хранилища данных
final storageProvider = Provider<IDataBase>((ref) => throw UnimplementedError());

// Провайдер выбора элемента всплывающего меню
final idProvider = StateProvider.autoDispose<int>((ref) => 0);

// Провайдер состояния подключения USB
final hidProvider = StateProvider.autoDispose<bool>((ref) => false);

// Провайдер значения ARR регистра
final arrProvider = StateProvider.autoDispose<int>((ref) => 0);

// Текущий угол поворота регулятора
final turnProvider = StateProvider.autoDispose<int>((ref) => 0);
