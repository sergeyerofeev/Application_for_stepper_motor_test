import 'package:flutter/material.dart';

import 'my_color_style.dart';

abstract class MyText {
  // Диалоговое окно выхода из приложения
  static const Text exitDialogTitle = Text('Вы действительно хотите закрыть приложение?',
      textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold));

  static const TextStyle exitDialogBool = TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);

  //
  // Главное окно приложения
  static const Text firstPageAppBarTitle =
      Text('Настройка', style: TextStyle(color: MyColorStyle.uiColor, fontSize: 18, fontWeight: FontWeight.bold));

  static const Text cardTitle1 = Text('Введите коэффициенты ПИД регулятора',
      textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600));

  static const Text cardTitle2 = Text('Задайте управляющее воздействие',
      textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600));

  //
  // Боковая панель на главной странице
  static const Text developerSubTitle = Text('Разработчик приложения:',
      style: TextStyle(color: MyColorStyle.drawerSubTitle, fontSize: 14, fontWeight: FontWeight.bold));

  static const Text developerTitle = Text('Ерофеев Сергей Владимирович',
      style: TextStyle(color: MyColorStyle.drawerTitle, fontSize: 16, fontWeight: FontWeight.bold));

  static const Text mailSubTitle =
      Text('Email:', style: TextStyle(color: MyColorStyle.drawerSubTitle, fontSize: 14, fontWeight: FontWeight.bold));

  static const Text mailTitle = Text('sergeyerofeev.ru@yandex.ru',
      style: TextStyle(color: MyColorStyle.drawerTitle, fontSize: 16, fontWeight: FontWeight.bold));

  //
  // Страница с инструкцией
  static const Text manualPageAppBarTitle =
      Text('Инструкция', style: TextStyle(color: MyColorStyle.uiColor, fontSize: 18, fontWeight: FontWeight.bold));

  //
  // Общие стили полей ввода
  static const TextStyle textFieldStyle = TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);
  static const TextStyle labelStyle = TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);
  static const TextStyle floatingLabelStyle = TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);
}
