import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/provider.dart';

import 'menu_config.dart';
import 'menu_item.dart';
import 'popup_menu.dart';

class MicroStepSelection extends ConsumerWidget {
  final GlobalKey btnKey = GlobalKey();

  MicroStepSelection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final microStep = ref.watch<int>(microStepProvider);
    final rotation = ref.watch<bool>(rotationProvider);

    final String selectStep = switch (microStep) {
      0 => 'Выбран полный шаг',
      1 => 'Выбрано 1/2 шага',
      2 => 'Выбрано 1/4 шага',
      3 => 'Выбрано 1/8 шага',
      4 => 'Выбрано 1/16 шага',
      _ => 'Недопустимое\nзначение',
    };

    return SizedBox(
      key: btnKey,
      height: 48.0,
      child: ElevatedButton(
        onPressed: (!rotation) ? () => onDismissOnlyBeCalledOnce(context) : null,
        child: Text(selectStep, textAlign: TextAlign.center),
      ),
    );
  }

  void onDismissOnlyBeCalledOnce(BuildContext context) {
    PopupMenu menu = PopupMenu(
      dataProvider: microStepProvider,
      config: const MenuConfig(
        itemWidth: 50.0,
        itemHeight: 50.0,
        horizontalMargin: 20.0,
        triangleHeight: 5.0,
        backgroundColor: Colors.white,
        dividingLineColor: Colors.grey,
        highlightColor: Colors.grey,
        border: BorderConfig(color: Colors.grey, width: 2.0),
        borderRadius: 5.0,
      ),
      duration: const Duration(milliseconds: 300),
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
    );
    menu.show(widgetKey: btnKey);
  }
}
