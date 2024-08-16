/// Пользовательское расширение объекта int для отделения пробелом тысячей
extension SeparateIntWithSpaces on int {
  String get priceString {
    final integerPart = toString();
    final sb = StringBuffer();
    final intStrLen = integerPart.length;
    for (int i = 0; i < intStrLen; i++) {
      sb.write(integerPart[i]);

      if ((intStrLen - i) % 3 == 1 && i != intStrLen - 1) {
        sb.write(' '); // Добавляем пробел после каждой тройки цифр
      }
    }
    return sb.toString();
  }
}

/// Пользовательское расширение объекта double для отделения пробелом тысячей
extension SeparateDoubleWithSpaces on double {
  String get priceString {
    final [integerPart, fractionaPart] = toStringAsFixed(1).split('.');
    final sb = StringBuffer();
    final intStrLen = integerPart.length;
    for (int i = 0; i < intStrLen; i++) {
      sb.write(integerPart[i]);

      if ((intStrLen - i) % 3 == 1 && i != intStrLen - 1) {
        sb.write(' '); // Добавляем пробел после каждой тройки цифр
      }
    }
    sb.writeAll([',', fractionaPart]);
    return sb.toString();
  }
}
