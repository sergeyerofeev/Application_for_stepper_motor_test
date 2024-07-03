import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/provider.dart';
import '../../settings/key_store.dart' as key_store;
import 'custom_text_input_formatter.dart';
import 'function_text_field.dart';

class PscField extends ConsumerStatefulWidget {
  const PscField({super.key});

  @override
  ConsumerState<PscField> createState() => _PscFieldState();
}

class _PscFieldState extends ConsumerState<PscField> {
  final TextEditingController _textEditingController = TextEditingController(text: '');

  @override
  void initState() {
    // Загружаем значение сохранённое при предыдущем запуске приложения
    Future(() async {
      final psc = await ref.read(storageProvider).get<int>(key_store.psc) ?? 0;
      if (mounted) {
        // Если число больше либо равно 1000 добавляем пробелы, для отделения тысячей
        setState(() => _textEditingController.text = psc < 1000 ? psc.toString() : ExtensionTextField(psc).priceString);
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
    final pscError = ref.watch(pscErrorProvider);
    final rotation = ref.watch<bool>(rotationProvider);

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
              labelText: 'Значение регистра PSC',
              suffixIcon: clearIconButton(
                clear: _textEditingController.clear,
                ref: ref,
                errorProvider: pscErrorProvider,
              ),
              errorText: pscError,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              CustomTextInputFormatter(),
            ],
            onChanged: (value) {
              if (pscError != null) {
                // Сбрасываем ошибку
                ref.read(pscErrorProvider.notifier).state = null;
              }
            },
            onSubmitted: (_) {
              validator();
            },
          ),
          // Задаём отступ для компенсации смещения нижних элементов в случае ошибки
          pscError != null ? const SizedBox(height: 17) : const SizedBox(height: 42),
        ],
      ),
    );
  }

  // Функция валидации ввода TextField
  void validator() {
    final text = _textEditingController.text.replaceAll(' ', '');

    if (text.isEmpty) {
      // Строка пустая
      ref.read(pscErrorProvider.notifier).state = 'Пожалуйста введите значение';
      return;
    }
    final value = int.tryParse(text);
    if (value == null) {
      ref.read(pscErrorProvider.notifier).state = 'Ошибка преобразования';
    } else if (value < 0 || value > 65535) {
      ref.read(pscErrorProvider.notifier).state = '0 \u2264 значение \u2264 65535';
    } else {
      // Отбрасываем начальные нули, добавляем для отделения тысячей, пробелы
      _textEditingController.text = ExtensionTextField(value).priceString;
      // Сохраняем преобразованное значение в провайдере
      ref.read(pscProvider.notifier).state = value;
    }
  }
}
