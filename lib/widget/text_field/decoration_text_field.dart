import 'package:flutter/material.dart';

/// Основной текст в поле ввода
const textStyle = TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold);

/// Стиль плавающего текста при перемещении в поле ввода
const labelStyle = TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold);

/// Стиль плавающего текста
const floatingLabelStyle = TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);

/// Стиль текста в случае ошибки ввода
const errorStyle = TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold);

/// Цвет и толшина рамки в разных режимах
const enabledBorder = OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 2.0));
const focusedBorder = OutlineInputBorder(borderSide: BorderSide(color: Colors.blue, width: 2.0));
const errorBorder = OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2.0));
const focusedErrorBorder = OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2.0));
