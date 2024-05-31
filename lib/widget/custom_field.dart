import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../settings/my_style.dart' as myStyle;

import '../settings/my_text.dart';

class CustomField extends ConsumerStatefulWidget {
  const CustomField({super.key});

  @override
  ConsumerState<CustomField> createState() => _UsernameFieldState();
}

class _UsernameFieldState extends ConsumerState<CustomField> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController(text: "hello" /*ref.read(usernameProvider)*/);
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
      //ref.read(usernameErrorProvider.notifier).state = 'Пожалуйста введите имя пользователя';
    }
    //ref.read(usernameProvider.notifier).state = _textEditingController.text;
  }

  @override
  Widget build(BuildContext context) {
    //final usernameError = ref.watch(usernameErrorProvider);
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
            style: MyText.textFieldStyle,
            decoration: InputDecoration(
              labelText: 'Имя пользователя',
              labelStyle: MyText.labelStyle,
              floatingLabelStyle: MyText.floatingLabelStyle,
              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 2.0)),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue, width: 3.0)),
              errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.deepOrange, width: 3.0)),
              focusedErrorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 3.0)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              suffixIcon: IconButton(
                highlightColor: Colors.transparent,
                onPressed: _textEditingController.clear,
                icon: const Icon(Icons.clear, color: Colors.grey),
              ),
              //errorText: usernameError,
            ),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[+0-9]'))],
            onChanged: (value) {
              /*final usernameError = ref.read(usernameErrorProvider);
              if (usernameError != null) {
                // Сбрасываем ошибку
                ref.read(usernameErrorProvider.notifier).state = null;
                setState(() {});
              }*/
            },
            onSubmitted: (_) {
              validator();
            },
          ),
          // Задаём отступ для компенсации смещения нижних элементов в случае ошибки
          //usernameError != null ? const SizedBox(height: 12) : const SizedBox(height: 35),
        ],
      ),
    );
  }
}
