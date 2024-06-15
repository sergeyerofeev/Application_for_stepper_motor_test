import 'package:flutter/material.dart';

import 'my_content.dart';
import '../widget/draggeble_app_bar.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: const MaterialStatePropertyAll<Color>(Colors.white),
            //foregroundColor: const MaterialStatePropertyAll<Color>(Colors.black),
            surfaceTintColor: const MaterialStatePropertyAll<Color>(Colors.white),
            padding: MaterialStateProperty.all(const EdgeInsets.all(10.0)),
            side: MaterialStateProperty.all(const BorderSide(color: Colors.grey, width: 2)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
            overlayColor: MaterialStateProperty.resolveWith(
              (states) {
                return states.contains(MaterialState.pressed) ? Colors.grey : Colors.white;
              },
            ),
          ),
        ),
      ),
      home: const DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0xFFFEFEFE),
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: DraggebleAppBar(),
          body: MyContent(),
        ),
      ),
    );
  }
}
