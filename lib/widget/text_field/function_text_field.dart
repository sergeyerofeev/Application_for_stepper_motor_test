import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Кнопка очистки поля ввода
Widget clearIconButton({
  required void Function() clear,
  required WidgetRef ref,
  required AutoDisposeStateProvider<String?> errorProvider,
}) {
  return Container(
    width: 40.0,
    height: 40.0,
    margin: const EdgeInsets.only(right: 5.0),
    child: InkWell(
      borderRadius: BorderRadius.circular(5.0),
      onTap: () {
        ref.read(errorProvider.notifier).state = 'Пожалуйста введите корректное значение';
        clear();
      },
      child: const Icon(Icons.clear, color: Colors.grey, size: 25),
    ),
  );
}

/// Пользовательское расширение для отделения пробелом тысячи
extension ExtensionTextField on int {
  String get priceString {
    final numberString = toString();
    final numberDigits = List<String>.from(numberString.split(''));
    int index = numberDigits.length - 3;
    while (index > 0) {
      numberDigits.insert(index, ' ');
      index -= 3;
    }
    return numberDigits.join();
  }
}

/// Функция валидации ввода TextField
void validator({
  required TextEditingController textEditingController,
  required WidgetRef ref,
  required AutoDisposeStateProvider<int> dataProvider,
  required AutoDisposeStateProvider<String?> errorProvider,
}) {
  final text = textEditingController.text.replaceAll(' ', '');
  if (text.isEmpty) {
    // Строка пустая
    ref.read(errorProvider.notifier).state = 'Пожалуйста введите корректное значение';
    return;
  }
  final value = int.tryParse(text);
  if (value == null) {
    ref.read(errorProvider.notifier).state = 'Ошибка преобразования';
  } else if (value == 0) {
    // Защита от множественного введения нулей
    textEditingController.text = 0.toString();
  } else if (value > 65535) {
    ref.read(errorProvider.notifier).state = 'Значение должно быть меньше, либо равно 65535';
  } else {
    // Отбрасываем начальные нули, добавляем для отделения тысячей, пробелы
    textEditingController.text = ExtensionTextField(value).priceString;
    // Сохраняем преобразованное значение в провайдере
    ref.read(dataProvider.notifier).state = value;
  }
}
