import 'package:flutter/services.dart';

class InputFormatterForInt extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.compareTo(oldValue.text.replaceAll(' ', '')) != 0) {
      int selectionIndexFromTheRight = oldValue.text.length - oldValue.selection.extentOffset;

      final sb = StringBuffer();
      final integerPart = newValue.text;
      final intStrLen = integerPart.length;

      for (int i = 0; i < intStrLen; i++) {
        sb.write(integerPart[i]);

        if ((intStrLen - i) % 3 == 1 && i != intStrLen - 1) {
          sb.write(' '); // Добавляем пробел после каждой тройки цифр
        }
      }
      final newStr = sb.toString();
      return TextEditingValue(
        text: newStr,
        selection: TextSelection.collapsed(
          offset: (newStr.length < selectionIndexFromTheRight) ? 0 : newStr.length - selectionIndexFromTheRight,
        ),
      );
    } else {
      return oldValue;
    }
  }
}
