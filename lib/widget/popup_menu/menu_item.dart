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
