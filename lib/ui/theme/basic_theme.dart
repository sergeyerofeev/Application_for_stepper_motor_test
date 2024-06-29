import 'package:flutter/material.dart';

import 'elevated_button_theme.dart';

ThemeData basicTheme() => ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.transparent,

      elevatedButtonTheme: elevatedButtonTheme(),

      // Стиль полей ввода
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        // Стиль плавающего текста при перемещении в поле ввода
        labelStyle: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        // Стиль плавающего текста в обычном и в неактивном состоянии enabled = false
        floatingLabelStyle: MaterialStateTextStyle.resolveWith(
          (Set<MaterialState> states) => (states.contains(MaterialState.disabled))
              ? const TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.bold)
              : const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // Цвет при наведении курсора на поле ввода
        hoverColor: Colors.white70,
        errorStyle: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold),
        // Цвет и толшина рамки в разных режимах
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey, width: 2.0)),
        disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300, width: 2.0)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent, width: 2.0)),
        errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2.0)),
        focusedErrorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2.0)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      ),
    );
