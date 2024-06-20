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
        ref.read(errorProvider.notifier).state = 'Пожалуйста введите значение';
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
