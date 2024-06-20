import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stepper_motor_test/provider/model.dart';

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
final arrMinProvider = StateProvider.autoDispose<int>((ref) => 0);
final arrMinErrorProvider = StateProvider.autoDispose<String?>((ref) => null);

// Провайдер максимального значения ARR регистра
final arrMaxProvider = StateProvider.autoDispose<int>((ref) => 65535);
final arrMaxErrorProvider = StateProvider.autoDispose<String?>((ref) => null);

// Провайдер текущего, передаваемого на микроконтроллер, значения ARR регистра
final currentArrProvider = StateProvider.autoDispose<int>((ref) => ref.read(arrMinProvider));

// Провайдер отслеживания нажатия кнопок изменения положения ручки регулятора
final buttonPressedProvider = StateProvider.autoDispose<int>((ref) => 0);

// Провайдер для минимального и максимального значений
class MinMaxNotifier extends AutoDisposeNotifier<MinMaxValue> {
  @override
  MinMaxValue build() {
    final min = ref.watch(arrMinProvider);
    final max = ref.watch(arrMaxProvider);
    return MinMaxValue(minValue: min, maxValue: max);
  }
}

final minMaxProvider = NotifierProvider.autoDispose<MinMaxNotifier, MinMaxValue>(MinMaxNotifier.new);
