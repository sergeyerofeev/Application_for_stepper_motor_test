import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/provider.dart';
import 'menu_config.dart';
import 'menu_item.dart';
import 'popup_menu.dart';

class DirectionSelection extends ConsumerWidget {
  final GlobalKey btnKey = GlobalKey();

  DirectionSelection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final direction = ref.watch<int>(directionProvider);
    final rotation = ref.watch<bool>(rotationProvider);

    final String directionSelect = switch (direction) {
      0 => 'Направление Dir = 0',
      1 => 'Направление Dir = 1',
      _ => 'Недопустимое\nзначение',
    };

    return SizedBox(
      key: btnKey,
      height: 48.0,
      child: ElevatedButton(
        onPressed: (!rotation) ? () => onDismissOnlyBeCalledOnce(context) : null,
        child: Text(directionSelect, textAlign: TextAlign.center),
      ),
    );
  }

  void onDismissOnlyBeCalledOnce(BuildContext context) {
    PopupMenu menu = PopupMenu(
      dataProvider: directionProvider,
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
        const MenuItem(id: 0, widget: Center(child: Icon(Icons.rotate_right))),
        const MenuItem(id: 1, widget: Center(child: Icon(Icons.rotate_left))),
      ],
    );
    menu.show(widgetKey: btnKey);
  }
}
