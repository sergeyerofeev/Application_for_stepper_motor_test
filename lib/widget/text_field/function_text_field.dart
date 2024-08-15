import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';

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

/// Кнопка загрузки тактовой частоты
Widget getSysClkButton() {
  return Container(
    width: 40.0,
    height: 40.0,
    margin: const EdgeInsets.only(right: 5.0),
    child: InkWell(
      borderRadius: BorderRadius.circular(5.0),
      onTap: () async {
        // Запрос на получение значения тактовой частоты
        const reportId = 6;
        final list = Uint8List.fromList([0, reportId, ...List.filled(7, 0)]);
        if (hid.open() == 0) {
          await hid.write(list);
        }
      },
      child: const Icon(Icons.file_download_outlined, color: Colors.grey, size: 25),
    ),
  );
}
