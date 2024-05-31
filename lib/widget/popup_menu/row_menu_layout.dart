import 'package:flutter/material.dart';

import 'menu_config.dart';
import 'menu_item.dart';
import 'menu_item_widget.dart';
import 'popup_menu.dart';

class RowMenuLayout {
  final MenuConfig _config;
  final List<PopUpMenuItemProvider> _items;
  final VoidCallback _onDismiss;
  final MenuClickCallback? _onClickMenu;

  // Количество элементов в меню
  late final int _itemsCount;

  // Ширина и высота всплывающего меню
  late final double _menuWidth;
  late final double _menuHeight;

  RowMenuLayout({
    required MenuConfig config,
    required List<PopUpMenuItemProvider> items,
    required void Function() onDismiss,
    void Function(PopUpMenuItemProvider)? onClickMenu,
  })  : _config = config,
        _items = items,
        _onDismiss = onDismiss,
        _onClickMenu = onClickMenu {
    _itemsCount = _items.length;
    _menuWidth = _config.itemWidth * _itemsCount + _config.border!.width * 2;
    _menuHeight = _config.itemHeight + _config.border!.width * 2;
  }

  List<Widget> _createRowItems() {
    List<Widget> itemWidgets = [];
    int i = 0;
    int itemsLength = _items.length - 1;
    for (var item in _items) {
      if (i == 0) {
        // У первого и последнего элемента в строке скругляем углы
        itemWidgets.add(
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_config.borderRadius),
              bottomLeft: Radius.circular(_config.borderRadius),
            ),
            child: _createMenuItem(item, i < (_itemsCount - 1)),
          ),
        );
      } else if (i == itemsLength) {
        itemWidgets.add(
          ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(_config.borderRadius),
              bottomRight: Radius.circular(_config.borderRadius),
            ),
            child: _createMenuItem(item, i < (_itemsCount - 1)),
          ),
        );
      } else {
        itemWidgets.add(_createMenuItem(item, i < (_itemsCount - 1)));
      }
      i++;
    }

    return itemWidgets;
  }

  Widget _createMenuItem(PopUpMenuItemProvider item, bool showLine) {
    return MenuItemWidget(
      itemWidth: _config.itemWidth,
      itemHeight: _config.itemHeight,
      item: item,
      showLine: showLine,
      clickCallback: itemClicked,
      lineColor: _config.lineColor,
      backgroundColor: _config.backgroundColor,
      highlightColor: _config.highlightColor,
    );
  }

  void itemClicked(PopUpMenuItemProvider item) {
    _onClickMenu?.call(item);
    _onDismiss();
  }

  Widget build() {
    return SizedBox(
      width: _menuWidth,
      height: _menuHeight,
      child: Container(
        width: _menuWidth,
        height: _menuHeight,
        decoration: BoxDecoration(
          color: _config.backgroundColor,
          border: _config.border != null
              ? Border.all(
                  color: _config.border!.color,
                  width: _config.border!.width,
                )
              : null,
          borderRadius: BorderRadius.all(Radius.circular(_config.borderRadius)),
        ),
        child: Row(children: _createRowItems()),
      ),
    );
  }

  double get width => _menuWidth;

  double get height => _menuHeight;
}
