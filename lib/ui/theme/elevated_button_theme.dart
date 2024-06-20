import 'package:flutter/material.dart';

ElevatedButtonThemeData elevatedButtonTheme() => ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: const MaterialStatePropertyAll<TextStyle>(TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const MaterialStatePropertyAll<Color>(Colors.white),
        foregroundColor: MaterialStateProperty.resolveWith(
          (states) {
            return states.contains(MaterialState.disabled) ? Colors.grey : Colors.black;
          },
        ),
        surfaceTintColor: const MaterialStatePropertyAll<Color>(Colors.white),
        padding: const MaterialStatePropertyAll(EdgeInsets.all(10.0)),
        side: const MaterialStatePropertyAll(BorderSide(color: Colors.grey, width: 2)),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.0),
          ),
        ),
        overlayColor: MaterialStateProperty.resolveWith(
          (states) {
            return states.contains(MaterialState.pressed) ? Colors.grey[300] : Colors.white;
          },
        ),
      ),
    );
