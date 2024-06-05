import 'package:flutter/material.dart';
import 'menu_item.dart';

class MenuItemWidget extends StatefulWidget {
  final MenuItem _item;
  final double _itemWidth;
  final double _itemHeight;
  final bool _showLine;
  final Color _lineColor;
  final Color _backgroundColor;
  final Color _highlightColor;
  final void Function(int) _clickCallback;

  const MenuItemWidget({
    super.key,
    required MenuItem item,
    required double itemWidth,
    required double itemHeight,
    required bool showLine,
    required Color lineColor,
    required Color backgroundColor,
    required Color highlightColor,
    required clickCallback,
  })  : _item = item,
        _itemWidth = itemWidth,
        _itemHeight = itemHeight,
        _showLine = showLine,
        _lineColor = lineColor,
        _backgroundColor = backgroundColor,
        _highlightColor = highlightColor,
        _clickCallback = clickCallback;

  @override
  State<StatefulWidget> createState() {
    return _MenuItemWidgetState();
  }
}

class _MenuItemWidgetState extends State<MenuItemWidget> {
  late Color _highlightColor;
  late Color _color;

  @override
  void initState() {
    _color = widget._backgroundColor;
    _highlightColor = widget._highlightColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() {
        _color = _highlightColor;
      }),
      onTap: () {
        _color = _highlightColor;
        widget._clickCallback.call(widget._item.id);
      },
      onLongPress: () {
        _color = _highlightColor;
        widget._clickCallback.call(widget._item.id);
      },
      child: Container(
          width: widget._itemWidth,
          height: widget._itemHeight,
          decoration: BoxDecoration(
            color: _color,
            border: Border(
              right: BorderSide(color: widget._showLine ? widget._lineColor : Colors.transparent),
            ),
          ),
          child: widget._item.widget),
    );
  }
}
