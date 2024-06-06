import 'dart:core';

import 'package:flutter/material.dart';

import 'row_menu_layout.dart';
import 'menu_config.dart';
import 'menu_item.dart';
import 'triangle_painter.dart';

class PopupMenu {
  final BuildContext _context;
  final MenuConfig _config;
  final List<MenuItem> _items;
  final Duration _duration;

  late final AnimationController _animationController;
  late final Size _screenSize;

  OverlayEntry? _entry;
  bool _isShow = false;

  PopupMenu({
    required BuildContext context,
    required MenuConfig config,
    required List<MenuItem> items,
    Duration duration = const Duration(milliseconds: 500),
  })  : _context = context,
        _config = config,
        _items = items,
        _duration = duration {
    // Инициализируем контроллер анимации
    _animationController = AnimationController(
      duration: _duration,
      vsync: Navigator.of(_context).overlay!,
    );
    // Вычисляем размер родительского элемента
    _screenSize = MediaQuery.of(context).size;
  }

  void show({required GlobalKey widgetKey}) {
    // При помощи переданного ключа базового виджета получаем его размеры
    RenderBox renderBox = widgetKey.currentContext!.findRenderObject() as RenderBox;
    // и смещение на экране
    Offset offset = renderBox.localToGlobal(Offset.zero);
    final attachRect = Rect.fromLTWH(offset.dx, offset.dy, renderBox.size.width, renderBox.size.height);

    // Создаём объект с переданными элементами меню
    RowMenuLayout menuLayout = RowMenuLayout(
      config: _config,
      items: _items,
      onDismiss: _dismiss,
    );

    LayoutP layout = _calculateOffset(
      _context,
      attachRect,
      menuLayout.width,
      menuLayout.height,
    );

    _entry = OverlayEntry(builder: (context) {
      return build(layout, menuLayout);
    });

    Overlay.of(_context).insert(_entry!);
    _isShow = true;
  }

  Widget build(LayoutP layout, RowMenuLayout menu) {
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
            Positioned(
              left: layout._offset.dx,
              top: layout._offset.dy + (_config.border.width * (layout._isDown ? -1 : 1.5)),
              child: menu.build(),
            ),
            Positioned(
              // Позиционируем треугольник всплывающего меню
              left: layout._attachRect.left +
                  (layout._attachRect.width - _config.triangleHeight - _config.border.width) / 2.0,
              top: layout._isDown
                  ? layout._offset.dy + layout._height - _config.border.width
                  : layout._offset.dy - _config.triangleHeight + _config.border.width,
              child: CustomPaint(
                size: Size(
                  _config.triangleHeight + _config.border.width,
                  _config.triangleHeight + _config.border.width,
                ),
                painter:
                    TrianglePainter(isDown: layout._isDown, color: _config.backgroundColor, border: _config.border),
              ),
            ), // menu content
          ],
        ),
      ),
    );

    child = _AnimatedPopUpMenu(
      controller: _animationController,
      child: child,
    );
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

    if (dx + contentWidth > _screenSize.width && dx > 10.0) {
      double tempDx = _screenSize.width - contentWidth - 10;
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
      return;
    }

    await _animationController.reverse();
    // Закрываем всплывающее окно
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
