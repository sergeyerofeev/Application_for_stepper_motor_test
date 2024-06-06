import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/provider.dart';
import 'menu_item.dart';

class MenuItemWidget extends ConsumerStatefulWidget {
  final MenuItem _item;
  final double _itemWidth;
  final double _itemHeight;
  final bool _showLine;
  final Color _lineColor;
  final Color _backgroundColor;
  final Color _highlightColor;
  final void Function() _dismissMenu;

  const MenuItemWidget({
    super.key,
    required MenuItem item,
    required double itemWidth,
    required double itemHeight,
    required bool showLine,
    required Color lineColor,
    required Color backgroundColor,
    required Color highlightColor,
    required dismissMenu,
  })  : _item = item,
        _itemWidth = itemWidth,
        _itemHeight = itemHeight,
        _showLine = showLine,
        _lineColor = lineColor,
        _backgroundColor = backgroundColor,
        _highlightColor = highlightColor,
        _dismissMenu = dismissMenu;

  @override
  ConsumerState<MenuItemWidget> createState() {
    return _MenuItemWidgetState();
  }
}

class _MenuItemWidgetState extends ConsumerState<MenuItemWidget> {
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
      onTap: () {
        setState(() {
          _color = _highlightColor;
        });
        ref.read(idProvider.notifier).state = widget._item.id;
        widget._dismissMenu();
      },
      onLongPress: () {
        setState(() {
          _color = _highlightColor;
        });
        ref.read(idProvider.notifier).state = widget._item.id;
        widget._dismissMenu();
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
        child: widget._item.widget,
      ),
    );
  }
}
