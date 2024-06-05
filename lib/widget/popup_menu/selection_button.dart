import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'menu_config.dart';
import 'menu_item.dart';
import 'popup_menu.dart';

class SelectionButton extends StatefulWidget {
  const SelectionButton({super.key});

  @override
  State<SelectionButton> createState() => _SelectionButtonState();
}

class _SelectionButtonState extends State<SelectionButton> {
  PopupMenu? menu;

  GlobalKey btnKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: btnKey,
      onPressed: onDismissOnlyBeCalledOnce,
      child: const Text('Настройка микрошага'),
    );
  }

  void onDismissOnlyBeCalledOnce() {
    menu = PopupMenu(
      config: const MenuConfig(
        itemWidth: 50.0,
        itemHeight: 50.0,
        backgroundColor: Colors.white,
        dividingLineColor: Colors.grey,
        highlightColor: Colors.grey,
        border: BorderConfig(color: Colors.grey, width: 2.0),
        triangleHeight: 5.0,
        borderRadius: 8.0,
      ),
      duration: const Duration(milliseconds: 500),
      context: context,
      items: [
        const MenuItem(
            id: 0,
            widget: Center(
                child: Text('1', style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold)))),
        const MenuItem(
            id: 1,
            widget: Center(
                child:
                    Text('1/2', style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold)))),
        const MenuItem(
            id: 2,
            widget: Center(
                child:
                    Text('1/4', style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold)))),
        const MenuItem(
            id: 3,
            widget: Center(
                child:
                    Text('1/8', style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold)))),
        const MenuItem(
            id: 4,
            widget: Center(
                child:
                    Text('1/16', style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold)))),
      ],
      onClickMenu: onClickMenu,
    );
    menu?.show(widgetKey: btnKey);
  }

  void onClickMenu(int id) {
    print('Click menu -> $id');
  }
}
