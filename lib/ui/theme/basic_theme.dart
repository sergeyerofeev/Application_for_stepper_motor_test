import 'package:flutter/material.dart';

import 'elevated_button_theme.dart';

ThemeData basicTheme() => ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.transparent,
      elevatedButtonTheme: elevatedButtonTheme(),
      // Стиль полей ввода
      inputDecorationTheme: const InputDecorationTheme(
        // Стиль плавающего текста при перемещении в поле ввода
        labelStyle: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        // Стиль плавающего текста
        floatingLabelStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        errorStyle: TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold),
        // Цвет и толшина рамки в разных режимах
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 2.0)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent, width: 2.0)),
        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2.0)),
        focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2.0)),
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      ),
    );
