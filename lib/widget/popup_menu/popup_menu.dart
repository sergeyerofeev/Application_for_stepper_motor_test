import 'dart:core';

import 'package:flutter/material.dart';

import 'row_menu_layout.dart';
import 'menu_config.dart';
import 'menu_item.dart';
import 'triangle_painter.dart';

typedef MenuClickCallback = void Function(PopUpMenuItemProvider item);

Rect getWidgetGlobalRect(GlobalKey key) {
  assert(key.currentContext != null, '');

  RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
  var offset = renderBox.localToGlobal(Offset.zero);
  return Rect.fromLTWH(offset.dx, offset.dy, renderBox.size.width, renderBox.size.height);
}

class PopupMenu {
  OverlayEntry? _entry;
  List<PopUpMenuItemProvider>? items;
  Widget? content;

  /// callback
  final VoidCallback? onDismiss;
  final MenuClickCallback? onClickMenu;
  final VoidCallback? onShow;
  final Duration? duration;

  /// Cannot be null
  BuildContext context;

  /// It's showing or not.
  bool _isShow = false;

  bool get isShow => _isShow;

  final MenuConfig config;
  Size? _screenSize;
  AnimationController? animationController;

  PopupMenu(
      {required this.context,
      required this.config,
      this.items,
      this.content,
      this.onClickMenu,
      this.onDismiss,
      this.onShow,
      this.duration});

  RowMenuLayout? menuLayout;

  void show({Rect? rect, GlobalKey? widgetKey}) {
    final attachRect = rect ?? getWidgetGlobalRect(widgetKey!);

    menuLayout = RowMenuLayout(
      config: config,
      items: items!,
      onDismiss: dismiss,
      onClickMenu: onClickMenu,
    );

    LayoutP layoutp = _calculateOffset(
      context,
      attachRect,
      menuLayout!.width,
      menuLayout!.height,
    );

    if (duration != null && animationController == null) {
      animationController = AnimationController(
        duration: duration!,
        vsync: Navigator.of(context).overlay!,
      );
    }

    _entry = OverlayEntry(builder: (context) {
      return build(layoutp, menuLayout!);
    });

    Overlay.of(context).insert(_entry!);
    _isShow = true;
    onShow?.call();
  }

  Widget build(LayoutP layoutp, RowMenuLayout menu) {
    Widget child = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        dismiss();
      },
      onVerticalDragStart: (DragStartDetails details) {
        dismiss();
      },
      onHorizontalDragStart: (DragStartDetails details) {
        dismiss();
      },
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: <Widget>[
            // triangle arrow
            Positioned(
              left: layoutp.offset.dx,
              top: layoutp.offset.dy + ((config.border?.width ?? 0) * (layoutp.isDown ? -1 : 1.5)),
              child: menu.build(),
            ),
            Positioned(
              left: layoutp.attachRect.left + layoutp.attachRect.width / 2.0 - 7.5,
              top: layoutp.isDown
                  ? layoutp.offset.dy + layoutp.height - ((config.border?.width ?? 0))
                  : layoutp.offset.dy - config.arrowHeight + ((config.border?.width ?? 0)),
              child: CustomPaint(
                size: Size(config.arrowHeight + (config.border?.width ?? 0) + 5,
                    config.arrowHeight + (config.border?.width ?? 0)),
                painter: TrianglePainter(isDown: layoutp.isDown, color: config.backgroundColor, border: config.border),
              ),
            ),
            // menu content
          ],
        ),
      ),
    );
    if (animationController != null) {
      child = AnimatedPopUpMenu(
        controller: animationController!,
        child: child,
      );
    }
    return child;
  }

  LayoutP _calculateOffset(
    BuildContext context,
    Rect attachRect,
    double contentWidth,
    double contentHeight,
  ) {
    double dx = attachRect.left + attachRect.width / 2.0 - contentWidth / 2.0;
    if (dx < 10.0) {
      dx = 10.0;
    }

    _screenSize ??= MediaQuery.of(context).size;

    if (dx + contentWidth > _screenSize!.width && dx > 10.0) {
      double tempDx = _screenSize!.width - contentWidth - 10;
      if (tempDx > 10) {
        dx = tempDx;
      }
    }
    // 5.0 это margin от верхней границы виджета до нижней границы стрелки
    double dy = attachRect.top - contentHeight - 5.0;
    bool isDown = false;
    if (dy <= MediaQuery.of(context).padding.top + 10) {
      // The have not enough space above, show menu under the widget.
      dy = config.arrowHeight + attachRect.height + attachRect.top;
      isDown = false;
    } else {
      dy -= config.arrowHeight;
      isDown = true;
    }

    return LayoutP(
      width: contentWidth,
      height: contentHeight,
      attachRect: attachRect,
      offset: Offset(dx, dy),
      isDown: isDown,
    );
  }

  void dismiss() async {
    if (!_isShow) {
      // Remove method should only be called once
      return;
    }
    if (animationController != null) {
      await animationController!.reverse();
    }
    _entry?.remove();
    _isShow = false;
    onDismiss?.call();
  }
}

class LayoutP {
  double width;
  double height;
  Offset offset;
  Rect attachRect;
  bool isDown;

  LayoutP({
    required this.width,
    required this.height,
    required this.offset,
    required this.attachRect,
    required this.isDown,
  });
}

class AnimatedPopUpMenu extends StatefulWidget {
  final Widget child;
  final AnimationController controller;

  const AnimatedPopUpMenu({required this.child, required this.controller, super.key});

  @override
  State<AnimatedPopUpMenu> createState() => _AnimatedPopUpMenuState();
}

class _AnimatedPopUpMenuState extends State<AnimatedPopUpMenu> with SingleTickerProviderStateMixin {
  late Animation<double> opacityAnimation;

  AnimationController get controller => widget.controller;

  @override
  void initState() {
    super.initState();

    opacityAnimation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  void dispose() async {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacityAnimation,
      child: widget.child,
    );
  }
}
