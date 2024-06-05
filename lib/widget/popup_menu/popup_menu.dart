import 'dart:core';

import 'package:flutter/material.dart';

import 'row_menu_layout.dart';
import 'menu_config.dart';
import 'menu_item.dart';
import 'triangle_painter.dart';

/*Rect getWidgetGlobalRect(GlobalKey key) {
  RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
  var offset = renderBox.localToGlobal(Offset.zero);
  return Rect.fromLTWH(offset.dx, offset.dy, renderBox.size.width, renderBox.size.height);
}*/

class PopupMenu {
  final BuildContext _context;
  final MenuConfig _config;
  final List<MenuItem> _items;
  final void Function(int) _onClickMenu;
  final Duration _duration;

  PopupMenu({
    required BuildContext context,
    required MenuConfig config,
    required List<MenuItem> items,
    required onClickMenu,
    Duration duration = const Duration(milliseconds: 500),
  })  : _context = context,
        _config = config,
        _items = items,
        _duration = duration,
        _onClickMenu = onClickMenu;

  OverlayEntry? _entry;

  // Видимость всплывающего меню
  bool _isShow = false;

  Size? _screenSize;
  AnimationController? _animationController;
  RowMenuLayout? _menuLayout;

  Rect getWidgetGlobalRect(GlobalKey key) {
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    return Rect.fromLTWH(offset.dx, offset.dy, renderBox.size.width, renderBox.size.height);
  }

  void show({required GlobalKey widgetKey}) {
    final attachRect = getWidgetGlobalRect(widgetKey);
    // Создаём объект с переданными элементами меню
    _menuLayout = RowMenuLayout(
      config: _config,
      items: _items,
      onDismiss: _dismiss,
      onClickMenu: _onClickMenu,
    );

    LayoutP layoutp = _calculateOffset(
      _context,
      attachRect,
      _menuLayout!.width,
      _menuLayout!.height,
    );

    _animationController ??= AnimationController(
      duration: _duration,
      vsync: Navigator.of(_context).overlay!,
    );

    _entry = OverlayEntry(builder: (context) {
      return build(layoutp, _menuLayout!);
    });

    Overlay.of(_context).insert(_entry!);
    _isShow = true;
  }

  Widget build(LayoutP layoutp, RowMenuLayout menu) {
    Widget child = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _dismiss();
      },
      onVerticalDragStart: (DragStartDetails details) {
        _dismiss();
      },
      onHorizontalDragStart: (DragStartDetails details) {
        _dismiss();
      },
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: <Widget>[
            // triangle arrow
            Positioned(
              left: layoutp._offset.dx,
              top: layoutp._offset.dy + (_config.border.width * (layoutp._isDown ? -1 : 1.5)),
              child: menu.build(),
            ),
            Positioned(
              // Позиционируем треугольник всплывающего меню
              left: layoutp._attachRect.left +
                  (layoutp._attachRect.width - _config.triangleHeight - _config.border.width) / 2.0,
              top: layoutp._isDown
                  ? layoutp._offset.dy + layoutp._height - _config.border.width
                  : layoutp._offset.dy - _config.triangleHeight + _config.border.width,
              child: CustomPaint(
                size: Size(
                  _config.triangleHeight + _config.border.width,
                  _config.triangleHeight + _config.border.width,
                ),
                painter:
                    TrianglePainter(isDown: layoutp._isDown, color: _config.backgroundColor, border: _config.border),
              ),
            ),
            // menu content
          ],
        ),
      ),
    );
    if (_animationController != null) {
      child = _AnimatedPopUpMenu(
        controller: _animationController!,
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
      dy = _config.triangleHeight + attachRect.height + attachRect.top;
      isDown = false;
    } else {
      dy -= _config.triangleHeight;
      isDown = true;
    }

    return LayoutP(
      height: contentHeight,
      attachRect: attachRect,
      offset: Offset(dx, dy),
      isDown: isDown,
    );
  }

  void _dismiss() async {
    if (!_isShow) {
      // Remove method should only be called once
      return;
    }
    if (_animationController != null) {
      await _animationController!.reverse();
    }
    _entry?.remove();
    _isShow = false;
  }
}

class LayoutP {
  final double _height;
  final Offset _offset;
  final Rect _attachRect;
  final bool _isDown;

  const LayoutP({
    required double height,
    required Offset offset,
    required Rect attachRect,
    required bool isDown,
  })  : _isDown = isDown,
        _attachRect = attachRect,
        _offset = offset,
        _height = height;
}

class _AnimatedPopUpMenu extends StatefulWidget {
  final Widget _child;
  final AnimationController _controller;

  const _AnimatedPopUpMenu({
    required Widget child,
    required AnimationController controller,
  })  : _controller = controller,
        _child = child;

  @override
  State<_AnimatedPopUpMenu> createState() => _AnimatedPopUpMenuState();
}

class _AnimatedPopUpMenuState extends State<_AnimatedPopUpMenu> with SingleTickerProviderStateMixin {
  late Animation<double> _opacityAnimation;

  AnimationController get controller => widget._controller;

  @override
  void initState() {
    super.initState();

    _opacityAnimation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

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
      opacity: _opacityAnimation,
      child: widget._child,
    );
  }
}
