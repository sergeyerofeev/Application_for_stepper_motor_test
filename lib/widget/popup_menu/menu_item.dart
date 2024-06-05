import 'package:flutter/material.dart';

class MenuItem {
  final int _id;
  final Widget _widget;

  const MenuItem({
    required int id,
    required Widget widget,
  })  : _id = id,
        _widget = widget;

  int get id => _id;

  Widget get widget => _widget;
}

/*abstract class PopUpMenuItemProvider {
  String get menuTitle;
  dynamic get menuUserInfo;
  Widget? get menuImage;
  TextStyle get menuTextStyle;
  TextAlign get menuTextAlign;
}

/// Default menu item
class PopUpMenuItem extends PopUpMenuItemProvider {
  Widget? image;
  String title;
  dynamic userInfo;
  TextStyle textStyle;
  TextAlign textAlign;

  PopUpMenuItem({
    this.title = "",
    this.image,
    this.userInfo,
    this.textStyle = const TextStyle(
      color: Color(0xffc5c5c5),
      fontSize: 10.0,
    ),
    this.textAlign = TextAlign.center,
  });

  factory PopUpMenuItem.forList({
    required String title,
    Widget? image,
    dynamic userInfo,
    TextStyle textStyle = const TextStyle(
      color: Color(0xFF181818),
      fontSize: 10.0,
    ),
    TextAlign textAlign = TextAlign.center,
  }) {
    return PopUpMenuItem(
      title: title,
      image: image,
      userInfo: userInfo,
      textAlign: textAlign,
      textStyle: textStyle,
    );
  }

  @override
  Widget? get menuImage => image;

  @override
  String get menuTitle => title;

  @override
  dynamic get menuUserInfo => userInfo;

  @override
  TextStyle get menuTextStyle => textStyle;

  @override
  TextAlign get menuTextAlign => textAlign;
}*/
