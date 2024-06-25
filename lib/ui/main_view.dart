import 'package:flutter/material.dart';

import '../widget/draggeble_app_bar.dart';
import 'my_content.dart';
import 'theme/basic_theme.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: basicTheme(),
      home: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFECECEC),
              Color(0xFFFFFFFF),
              Color(0xFFFFFFFF),
              Color(0xFFECECEC),
            ],
            stops: [0.26, 0.585, 0.625, 0.95],
          ),
        ),
        child: const Scaffold(
          appBar: DraggebleAppBar(),
          body: MyContent(),
        ),
      ),
    );
  }
}
