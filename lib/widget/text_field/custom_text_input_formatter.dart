import 'package:flutter/services.dart';

class CustomTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      int selectionIndexFromTheRight = newValue.text.length - newValue.selection.extentOffset;
      List<String> chars = newValue.text.replaceAll(' ', '').split('').reversed.toList();
      StringBuffer sb = StringBuffer();
      if (RegExp(r'\.').hasMatch(newValue.text)) {
        int indexDot = chars.indexOf('.') + 1;
        for (int j = 0; j < indexDot; ++j) {
          sb.write(chars[j]);
        }

        chars = chars.sublist(indexDot);

        for (int i = 0; i < chars.length; i++) {
          if (i % 3 == 0 && i != 0) sb.write(' ');
          sb.write(chars[i]);
        }
      } else {
        for (int i = 0; i < chars.length; i++) {
          if (i % 3 == 0 && i != 0) sb.write(' ');
          sb.write(chars[i]);
        }
      }

      chars = sb.toString().split('').reversed.toList();
      sb.clear();

      final String newString = chars.join('');

      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndexFromTheRight,
        ),
      );
    } else {
      return newValue;
    }
  }
}
