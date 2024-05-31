import 'package:flutter/material.dart';

class MenuConfig {
  final double itemWidth;

  final double itemHeight;

  final double arrowHeight;

  final Color backgroundColor;

  final Color highlightColor;

  final Color lineColor;

  final BorderConfig? border;

  final double borderRadius;

  const MenuConfig({
    this.itemWidth = 72.0,
    this.itemHeight = 75.0,
    this.arrowHeight = 10.0,
    this.backgroundColor = const Color(0xff232323),
    this.highlightColor = const Color(0xff353535),
    this.lineColor = const Color(0x55000000),
    this.border,
    this.borderRadius = 10.0,
  });
}

class BorderConfig {
  final Color color;
  final double width;

  BorderConfig({this.color = const Color(0xFF000000), this.width = 1.0});
}
