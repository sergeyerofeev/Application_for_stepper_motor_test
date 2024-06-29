import 'package:flutter/material.dart';

ElevatedButtonThemeData elevatedButtonTheme() => ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: const MaterialStatePropertyAll<TextStyle>(
          TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const MaterialStatePropertyAll<Color>(Colors.white12),
        elevation: const MaterialStatePropertyAll<double>(10.0),
        shadowColor: const MaterialStatePropertyAll<Color>(Colors.white30),
        foregroundColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.disabled) ? Colors.grey : Colors.black,
        ),
        surfaceTintColor: const MaterialStatePropertyAll<Color>(Colors.white),
        padding: const MaterialStatePropertyAll(EdgeInsets.all(10.0)),
        side: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.disabled)
              ? BorderSide(color: Colors.grey.shade300, width: 2)
              : const BorderSide(color: Colors.blueGrey, width: 2),
        ),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        overlayColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.pressed) ? Colors.grey[300] : Colors.white70,
        ),
      ),
    );
