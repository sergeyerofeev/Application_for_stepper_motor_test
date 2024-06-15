import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/data_sources/i_data_base.dart';

// Провайдер хранилища данных
final storageProvider = Provider<IDataBase>((ref) => throw UnimplementedError());

// Провайдер состояния подключения USB
final hidProvider = StateProvider.autoDispose<bool>((ref) => false);

// Провайдер выбора значения микро шага драйвера
final microStepProvider = StateProvider.autoDispose<int>((ref) => 0);

// Провайдер выбора значения угла шага двигателя
final stepAngleProvider = StateProvider.autoDispose<int>((ref) => 0);

// Провайдер выбора значения направления вращения двигателя
final directionProvider = StateProvider.autoDispose<int>((ref) => 0);

// Провайдер значения PSC регистра
final pscProvider = StateProvider.autoDispose<int>((ref) => 0);
final pscErrorProvider = StateProvider.autoDispose<String?>((ref) => null);

// Провайдер максимального значения ARR регистра
final arrProvider = StateProvider.autoDispose<int>((ref) => 0);
final arrErrorProvider = StateProvider.autoDispose<String?>((ref) => null);

// Провайдер текущего, передаваемого на микроконтроллер, значения ARR регистра
final currentArrProvider = StateProvider.autoDispose<int>((ref) => 0);

// Текущий угол поворота регулятора
final turnProvider = StateProvider.autoDispose<int>((ref) => 0);
