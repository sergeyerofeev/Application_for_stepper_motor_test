import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/provider.dart';
import '../../settings/extension.dart';
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
    // Загружаем сохранённое значение
    final arrMin = ref.read(arrMinProvider);
    // Если число больше либо равно 1000 добавляем пробелы, для отделения тысячей
    _textEditingController.text = arrMin < 1000 ? arrMin.toString() : SeparateIntWithSpaces(arrMin).priceString;
    setState(() {});

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
    ref.listen<int>(arrMaxProvider, (previous, next) {
      validator();
    });

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
      final intToStr = SeparateIntWithSpaces(value).priceString;
      if (_textEditingController.text.length != intToStr.length) {
        // Перезаписываем поле ввода только при изменении длины, т.е. были начальные нули
        _textEditingController.text = intToStr;
      }
      if (value != ref.read(arrMinProvider)) {
        // Сохраняем преобразованное значение в провайдере
        ref.read(arrMinProvider.notifier).state = value;
      }
    }
  }
}
