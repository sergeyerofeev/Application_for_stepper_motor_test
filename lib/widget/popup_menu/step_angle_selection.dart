import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/provider.dart';
import 'menu_config.dart';
import 'menu_item.dart';
import 'popup_menu.dart';

class StepAngleSelection extends ConsumerWidget {
  final GlobalKey btnKey = GlobalKey();

  StepAngleSelection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stepAngle = ref.watch<int>(stepAngleProvider);
    final rotation = ref.watch<bool>(rotationProvider);

    final String selectAngle = switch (stepAngle) {
      0 => 'Угол шага 0,9\u00B0',
      1 => 'Угол шага 1,8\u00B0',
      2 => 'Угол шага 3,6\u00B0',
      3 => 'Угол шага 5,625\u00B0',
      4 => 'Угол шага 7,5\u00B0',
      _ => 'Недопустимое\nзначение',
    };

    return SizedBox(
      key: btnKey,
      height: 48.0,
      child: ElevatedButton(
        onPressed: (!rotation) ? () => onDismissOnlyBeCalledOnce(context) : null,
        child: Text(selectAngle, textAlign: TextAlign.center),
      ),
    );
  }

  void onDismissOnlyBeCalledOnce(BuildContext context) {
    PopupMenu menu = PopupMenu(
      dataProvider: stepAngleProvider,
      config: const MenuConfig(
        itemWidth: 60.0,
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
                child: Text('0,9\u00B0',
                    style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold)))),
        const MenuItem(
            id: 1,
            widget: Center(
                child: Text('1,8\u00B0',
                    style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold)))),
        const MenuItem(
            id: 2,
            widget: Center(
                child: Text('3,6\u00B0',
                    style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold)))),
        const MenuItem(
            id: 3,
            widget: Center(
                child: Text('5,625\u00B0',
                    style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold)))),
        const MenuItem(
            id: 4,
            widget: Center(
                child: Text('7,5\u00B0',
                    style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold)))),
      ],
    );
    menu.show(widgetKey: btnKey);
  }
}
