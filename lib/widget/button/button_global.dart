import 'package:flutter/material.dart';

const double height = 52.0;

Widget buttonTitle({required String text, Color? textColor}) => Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(color: textColor, fontSize: 14),
    );
