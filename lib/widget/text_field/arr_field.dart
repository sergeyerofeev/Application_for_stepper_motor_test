import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/provider.dart';
import '../../settings/key_store.dart' as key_store;
import 'custom_text_input_formatter.dart';
import 'decoration_text_field.dart' as decoration;
import 'function_text_field.dart';

class AutoReloadField extends ConsumerStatefulWidget {
  const AutoReloadField({super.key});

  @override
  ConsumerState<AutoReloadField> createState() => _AutoReloadFieldState();
}

class _AutoReloadFieldState extends ConsumerState<AutoReloadField> {
  final TextEditingController _textEditingController = TextEditingController(text: '');

  @override
  void initState() {
    // Загружаем значение сохранённое при предыдущем запуске приложения
    Future(() async {
      final arr = await ref.read(storageProvider).get<int>(key_store.arr) ?? 0;
      if (mounted) {
        setState(() => _textEditingController.text = arr.toString());
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
    final arrError = ref.watch(arrErrorProvider);
    return Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          validator(
            textEditingController: _textEditingController,
            ref: ref,
            dataProvider: arrProvider,
            errorProvider: arrErrorProvider,
          );
        }
      },
      child: Column(
        children: [
          TextField(
            controller: _textEditingController,
            style: decoration.textStyle,
            decoration: InputDecoration(
              labelText: 'Значение регистра ARR',
              labelStyle: decoration.labelStyle,
              floatingLabelStyle: decoration.floatingLabelStyle,
              errorStyle: decoration.errorStyle,
              enabledBorder: decoration.enabledBorder,
              focusedBorder: decoration.focusedBorder,
              errorBorder: decoration.errorBorder,
              focusedErrorBorder: decoration.focusedBorder,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              suffixIcon: clearIconButton(
                clear: _textEditingController.clear,
                ref: ref,
                errorProvider: arrErrorProvider,
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
                ref.read(arrErrorProvider.notifier).state = null;
              }
            },
            onSubmitted: (_) {
              validator(
                textEditingController: _textEditingController,
                ref: ref,
                dataProvider: arrProvider,
                errorProvider: arrErrorProvider,
              );
            },
          ),
          // Задаём отступ для компенсации смещения нижних элементов в случае ошибки
          arrError != null ? const SizedBox(height: 17) : const SizedBox(height: 42),
        ],
      ),
    );
  }
}
