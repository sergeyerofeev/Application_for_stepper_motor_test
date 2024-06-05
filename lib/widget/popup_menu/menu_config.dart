import 'package:flutter/material.dart';

class MenuConfig {
  // Ширина одного элемента выпадающего меню
  final double _itemWidth;

  // Высота одного элемента выпадающего меню
  final double _itemHeight;

  final double _triangleHeight;

  final Color _backgroundColor;

  final Color _highlightColor;

  // Цвет разделительной линии между элементами выпадающего меню
  final Color _dividingLineColor;

  final BorderConfig _border;

  final double _borderRadius;

  const MenuConfig({
    double itemWidth = 50.0,
    double itemHeight = 50.0,
    double triangleHeight = 10.0,
    Color backgroundColor = const Color(0xffe5e5e5),
    Color highlightColor = const Color(0xffb4b4b4),
    Color dividingLineColor = const Color(0xff989898),
    BorderConfig border = const BorderConfig(),
    double borderRadius = 5.0,
  })  : _itemWidth = itemWidth,
        _itemHeight = itemHeight,
        _triangleHeight = triangleHeight,
        _backgroundColor = backgroundColor,
        _highlightColor = highlightColor,
        _dividingLineColor = dividingLineColor,
        _border = border,
        _borderRadius = borderRadius;

  double get itemWidth => _itemWidth;

  double get itemHeight => _itemHeight;

  double get triangleHeight => _triangleHeight;

  Color get backgroundColor => _backgroundColor;

  Color get highlightColor => _highlightColor;

  Color get dividingLineColor => _dividingLineColor;

  BorderConfig get border => _border;

  double get borderRadius => _borderRadius;
}

class BorderConfig {
  final Color _color;
  final double _width;

  const BorderConfig({
    Color color = Colors.transparent,
    double width = 0.0,
  })  : _color = color,
        _width = width;

  Color get color => _color;

  double get width => _width;
}
