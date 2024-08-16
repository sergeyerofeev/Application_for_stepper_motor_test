import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/provider.dart';
import '../../settings/extension.dart';
import 'input_formatter_for_int.dart';
import 'functions_for_text_field.dart';

class ArrMaxField extends ConsumerStatefulWidget {
  const ArrMaxField({super.key});

  @override
  ConsumerState<ArrMaxField> createState() => _ArrMaxFieldState();
}

class _ArrMaxFieldState extends ConsumerState<ArrMaxField> {
  final TextEditingController _textEditingController = TextEditingController(text: '');

  @override
  void initState() {
    // Загружаем сохранённое значение
    final arrMax = ref.read(arrMaxProvider);
    // Если число больше либо равно 1000 добавляем пробелы, для отделения тысячей
    _textEditingController.text = arrMax < 1000 ? arrMax.toString() : SeparateIntWithSpaces(arrMax).priceString;
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
    final arrError = ref.watch(arrMaxErrorProvider);
    ref.listen<int>(arrMinProvider, (previous, next) {
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
              labelText: 'MAX значение ARR',
              suffixIcon: clearIconButton(
                clear: _textEditingController.clear,
                ref: ref,
                errorProvider: arrMaxErrorProvider,
              ),
              errorText: arrError,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              InputFormatterForInt(),
            ],
            onChanged: (value) {
              if (arrError != null) {
                // Сбрасываем ошибку
                ref.read(arrMaxErrorProvider.notifier).state = null;
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
    final min = ref.read(arrMinProvider);
    if (text.isEmpty) {
      // Строка пустая
      ref.read(arrMaxErrorProvider.notifier).state = 'Пожалуйста введите значение';
      return;
    }
    final value = int.tryParse(text);
    if (value == null) {
      ref.read(arrMaxErrorProvider.notifier).state = 'Ошибка преобразования';
    } else if (value <= min || value > 65535) {
      ref.read(arrMaxErrorProvider.notifier).state = '$min \u003C значение \u2264 65535';
    } else {
      // Отбрасываем начальные нули, добавляем для отделения тысячей, пробелы
      final intToStr = SeparateIntWithSpaces(value).priceString;
      if (_textEditingController.text.length != intToStr.length) {
        // Перезаписываем поле ввода только при изменении длины, т.е. были начальные нули
        _textEditingController.text = intToStr;
      }
      if (value != ref.read(arrMaxProvider)) {
        // Сохраняем преобразованное значение в провайдере
        ref.read(arrMaxProvider.notifier).state = value;
      }
    }
  }
}
