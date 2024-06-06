import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stepper_motor_test/provider/provider.dart';

import 'menu_config.dart';
import 'menu_item.dart';
import 'popup_menu.dart';

class MicroStepSelection extends ConsumerWidget {
  final GlobalKey btnKey = GlobalKey();

  MicroStepSelection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch<int>(idProvider);
    late final String selectStep;

    switch (id) {
      case 0:
        selectStep = 'Выбран полный шаг';
      case 1:
        selectStep = 'Выбрано 1/2 шага';
      case 2:
        selectStep = 'Выбрано 1/4 шага';
      case 3:
        selectStep = 'Выбрано 1/8 шага';
      case 4:
        selectStep = 'Выбрано 1/16 шага';
    }

    return ElevatedButton(
      key: btnKey,
      onPressed: () => onDismissOnlyBeCalledOnce(context),
      child: Text(
        selectStep,
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  void onDismissOnlyBeCalledOnce(BuildContext context) {
    PopupMenu menu = PopupMenu(
      config: const MenuConfig(
        itemWidth: 50.0,
        itemHeight: 50.0,
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
