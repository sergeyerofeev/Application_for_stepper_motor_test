import 'package:flutter/material.dart';

import 'my_content.dart';
import '../widget/draggeble_app_bar.dart';
import 'theme/basic_theme.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: basicTheme(),
      home: const DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0xFFFEFEFE),
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          appBar: DraggebleAppBar(),
          body: MyContent(),
        ),
      ),
    );
  }
}
