/// Пользовательское расширение объекта int для отделения пробелом тысячей
extension SeparateIntWithSpaces on int {
  String get priceString {
    final integerPart = toString();
    final sb = StringBuffer();
    for (int i = 0; i < integerPart.length; i++) {
      sb.write(integerPart[i]);

      if ((integerPart.length - i) % 3 == 1 && i != integerPart.length - 1) {
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
    for (int i = 0; i < integerPart.length; i++) {
      sb.write(integerPart[i]);

      if ((integerPart.length - i) % 3 == 1 && i != integerPart.length - 1) {
        sb.write(' '); // Добавляем пробел после каждой тройки цифр
      }
    }
    sb.writeAll([',', fractionaPart]);
    return sb.toString();
  }
}
