import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/provider.dart';
import '../../settings/key_store.dart' as key_store;
import 'custom_text_input_formatter.dart';
import 'function_text_field.dart';

class ArrMinField extends ConsumerStatefulWidget {
  const ArrMinField({super.key});

  @override
  ConsumerState<ArrMinField> createState() => _ArrMinFieldState();
}

class _ArrMinFieldState extends ConsumerState<ArrMinField> {
  final TextEditingController _textEditingController = TextEditingController(text: '');

  @override
  void initState() {
    // Загружаем значение сохранённое при предыдущем запуске приложения
    Future(() async {
      final arrMin = await ref.read(storageProvider).get<int>(key_store.arrMin) ?? 0;
      if (mounted) {
        setState(() => _textEditingController.text = arrMin.toString());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arrError = ref.watch(arrMinErrorProvider);
    return Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          validator();
        }
      },
      child: Column(
        children: [
          TextField(
            controller: _textEditingController,
            style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              labelText: 'MIN значение ARR',
              suffixIcon: clearIconButton(
                clear: _textEditingController.clear,
                ref: ref,
                errorProvider: arrMinErrorProvider,
              ),
              errorText: arrError,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              CustomTextInputFormatter(),
            ],
            onChanged: (value) {
              if (arrError != null) {
                // Сбрасываем ошибку
                ref.read(arrMinErrorProvider.notifier).state = null;
              }
            },
            onSubmitted: (_) {
              validator();
            },
          ),
          // Задаём отступ для компенсации смещения нижних элементов в случае ошибки
          arrError != null ? const SizedBox(height: 17) : const SizedBox(height: 42),
        ],
      ),
    );
  }

  // Функция валидации ввода TextField
  void validator() {
    final text = _textEditingController.text.replaceAll(' ', '');
    final max = ref.read(arrMaxProvider);
    if (text.isEmpty) {
      // Строка пустая
      ref.read(arrMinErrorProvider.notifier).state = 'Пожалуйста введите значение';
      return;
    }
    final value = int.tryParse(text);
    if (value == null) {
      ref.read(arrMinErrorProvider.notifier).state = 'Ошибка преобразования';
    } else if (value < 0 || value >= max) {
      ref.read(arrMinErrorProvider.notifier).state = '0 \u2264 значение \u003C $max';
    } else {
      // Отбрасываем начальные нули, добавляем для отделения тысячей, пробелы
      _textEditingController.text = ExtensionTextField(value).priceString;
      // Сохраняем преобразованное значение в провайдере
      ref.read(arrMinProvider.notifier).state = value;
    }
  }
}
