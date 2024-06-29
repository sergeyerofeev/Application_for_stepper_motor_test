import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stepper_motor_test/provider/model.dart';

import '../data/data_sources/i_data_base.dart';

// Провайдер хранилища данных
final storageProvider = Provider<IDataBase>((ref) => throw UnimplementedError());

// Провайдер состояния подключения USB: true - подключено, false - обрыв соединения
final connectProvider = StateProvider.autoDispose<bool>((ref) => false);

// Провайдер выбора значения микро шага драйвера
final microStepProvider = StateProvider.autoDispose<int>((ref) => throw UnimplementedError());

// Провайдер выбора значения направления вращения двигателя
final directionProvider = StateProvider.autoDispose<int>((ref) => throw UnimplementedError());

// Провайдер выбора значения угла шага двигателя
final stepAngleProvider = StateProvider.autoDispose<int>((ref) => throw UnimplementedError());

// Провайдер значения PSC регистра
final pscProvider = StateProvider<int>((ref) => throw UnimplementedError());
final pscErrorProvider = StateProvider.autoDispose<String?>((ref) => null);

// Провайдер максимального значения ARR регистра
final arrMinProvider = StateProvider.autoDispose<int>((ref) => throw UnimplementedError());
final arrMinErrorProvider = StateProvider.autoDispose<String?>((ref) => null);

// Провайдер максимального значения ARR регистра
final arrMaxProvider = StateProvider.autoDispose<int>((ref) => throw UnimplementedError());
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

// Провайдер запуска true и остановки false врещения двигателя
final rotationProvider = StateProvider.autoDispose<bool>((ref) {
  final isConnect = ref.watch(connectProvider);
  // Если произошёл обрыв соединения USB выключаем флаг запуска двигателя
  if (!isConnect) return false;
  return false;
});
