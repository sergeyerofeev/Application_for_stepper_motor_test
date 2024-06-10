import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stepper_motor_test/provider/provider.dart';
import '../../settings/key_store.dart' as key_store;

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

  void validator() {
    if (_textEditingController.text.isEmpty) {
      // Строка пустая
      ref.read(pscErrorProvider.notifier).state = 'Пожалуйста введите значение для PSC регистра';
      return;
    }
    if (int.tryParse(_textEditingController.text) != null) {
      ref.read(pscProvider.notifier).state = int.tryParse(_textEditingController.text)!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pscError = ref.watch(pscErrorProvider);
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
              labelText: 'Значение регистра PSC',
              labelStyle: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
              floatingLabelStyle: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 2.0)),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue, width: 3.0)),
              errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.deepOrange, width: 3.0)),
              focusedErrorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 3.0)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              suffixIcon: IconButton(
                highlightColor: Colors.transparent,
                onPressed: _textEditingController.clear,
                icon: const Icon(Icons.clear, color: Colors.grey),
              ),
              errorText: pscError,
            ),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
            onChanged: (value) {
              if (pscError != null) {
                // Сбрасываем ошибку
                ref.read(pscErrorProvider.notifier).state = null;
                setState(() {});
              }
            },
            onSubmitted: (_) {
              validator();
            },
          ),
          // Задаём отступ для компенсации смещения нижних элементов в случае ошибки
          pscError != null ? const SizedBox(height: 12) : const SizedBox(height: 36),
        ],
      ),
    );
  }
}
