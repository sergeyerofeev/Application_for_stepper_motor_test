import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'decoration_text_field.dart' as decoration;
import 'function_text_field.dart';
import '../../settings/key_store.dart' as key_store;
import '../../provider/provider.dart';
import 'custom_text_input_formatter.dart';

class PrescalerField extends ConsumerStatefulWidget {
  const PrescalerField({super.key});

  @override
  ConsumerState<PrescalerField> createState() => _PrescalerFieldState();
}

class _PrescalerFieldState extends ConsumerState<PrescalerField> {
  final TextEditingController _textEditingController = TextEditingController(text: '');

  @override
  void initState() {
    // Загружаем значение сохранённое при предыдущем запуске приложения
    Future(() async {
      final psc = await ref.read(storageProvider).get<int>(key_store.psc) ?? 0;
      if (mounted) {
        setState(() => _textEditingController.text = psc.toString());
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
    return Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          validator(
            textEditingController: _textEditingController,
            ref: ref,
            dataProvider: pscProvider,
            errorProvider: pscErrorProvider,
          );
        }
      },
      child: Column(
        children: [
          TextField(
            controller: _textEditingController,
            style: decoration.textStyle,
            decoration: InputDecoration(
              labelText: 'Значение регистра PSC',
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
              validator(
                textEditingController: _textEditingController,
                ref: ref,
                dataProvider: pscProvider,
                errorProvider: pscErrorProvider,
              );
            },
          ),
          // Задаём отступ для компенсации смещения нижних элементов в случае ошибки
          pscError != null ? const SizedBox(height: 17) : const SizedBox(height: 42),
        ],
      ),
    );
  }
}
