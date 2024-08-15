import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/provider.dart';
import '../../settings/extension.dart';
import 'custom_text_input_formatter.dart';
import 'function_text_field.dart';

class SysClkField extends ConsumerStatefulWidget {
  const SysClkField({super.key});

  @override
  ConsumerState<SysClkField> createState() => _SysClkFieldState();
}

class _SysClkFieldState extends ConsumerState<SysClkField> {
  final TextEditingController _textEditingController = TextEditingController(text: '');

  @override
  void initState() {
    // Загружаем сохранённое значение
    final sysclk = ref.read(sysclkProvider).$1;
    // Если число больше либо равно 1000 добавляем пробелы, для отделения тысячей
    _textEditingController.text = sysclk < 1000 ? sysclk.toString() : SeparateIntWithSpaces(sysclk).priceString;
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
    final sysclkError = ref.watch(sysclkErrorProvider);
    final rotation = ref.watch<bool>(rotationProvider);

    ref.listen(sysclkProvider, (previous, next) {
      // Добавляем для отделения тысячей, пробелы
      _textEditingController.text = SeparateIntWithSpaces(next.$1).priceString;
      setState(() {});
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
            // Если вращение запущено, запрещаем редактирование
            enabled: !rotation,
            style: MaterialStateTextStyle.resolveWith(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold);
                } else {
                  return const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold);
                }
              },
            ),
            decoration: InputDecoration(
              labelText: 'Значение SYSCLK',
              suffixIcon: getSysClkButton(),
              errorText: sysclkError,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              CustomTextInputFormatter(),
            ],
            onChanged: (value) {
              if (sysclkError != null) {
                // Сбрасываем ошибку
                ref.read(sysclkErrorProvider.notifier).state = null;
              }
            },
            onSubmitted: (_) {
              validator();
            },
          ),
          // Задаём отступ для компенсации смещения нижних элементов в случае ошибки
          sysclkError != null ? const SizedBox(height: 17) : const SizedBox(height: 42),
        ],
      ),
    );
  }

  // Функция валидации ввода TextField
  void validator() {
    final text = _textEditingController.text.replaceAll(' ', '');

    if (text.isEmpty) {
      // Строка пустая
      ref.read(sysclkErrorProvider.notifier).state = 'Пожалуйста введите значение';
      return;
    }
    final value = int.tryParse(text);
    if (value == null) {
      ref.read(sysclkErrorProvider.notifier).state = 'Ошибка преобразования';
    } else if (value < 0 || value > 400000000) {
      ref.read(sysclkErrorProvider.notifier).state = '0 \u2264 значение \u2264 400 000 000';
    } else {
      // Отбрасываем начальные нули, добавляем для отделения тысячей, пробелы
      final intToStr = SeparateIntWithSpaces(value).priceString;
      if (_textEditingController.text.length != intToStr.length) {
        // Перезаписываем поле ввода только при изменении длины, т.е. были начальные нули
        _textEditingController.text = intToStr;
      }
      if (value != ref.read(sysclkProvider).$1) {
        // Сохраняем преобразованное значение в провайдере
        ref.read(sysclkProvider.notifier).state = (value,);
      }
    }
  }
}
