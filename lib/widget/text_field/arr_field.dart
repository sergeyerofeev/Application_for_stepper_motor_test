import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stepper_motor_test/provider/provider.dart';
import '../../settings/key_store.dart' as key_store;

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

  void validator() {
    if (_textEditingController.text.isEmpty) {
      // Строка пустая
      ref.read(arrErrorProvider.notifier).state = 'Пожалуйста введите значение для ARR регистра';
      return;
    }
    if (int.tryParse(_textEditingController.text) != null) {
      ref.read(arrProvider.notifier).state = int.tryParse(_textEditingController.text)!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final arrError = ref.watch(arrErrorProvider);
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
              labelText: 'Значение регистра ARR',
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
              errorText: arrError,
            ),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[+0-9]'))],
            onChanged: (value) {
              if (arrError != null) {
                // Сбрасываем ошибку
                ref.read(arrErrorProvider.notifier).state = null;
                setState(() {});
              }
            },
            onSubmitted: (_) {
              validator();
            },
          ),
          // Задаём отступ для компенсации смещения нижних элементов в случае ошибки
          arrError != null ? const SizedBox(height: 12) : const SizedBox(height: 36),
        ],
      ),
    );
  }
}
