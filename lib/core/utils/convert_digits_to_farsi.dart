// this method is use to convert the farsi number to english number
import 'package:flutter/material.dart';

String convertDigitsToFarsi(String input) {
  const digitsMap = {
    '0': '۰',
    '1': '۱',
    '2': '۲',
    '3': '۳',
    '4': '۴',
    '5': '۵',
    '6': '۶',
    '7': '۷',
    '8': '۸',
    '9': '۹',
  };

  return input.replaceAllMapped(RegExp(r'\d'), (match) {
    return digitsMap[match.group(0)]!;
  }).replaceAll(' ', '');
}

extension MediaQueryExtension on BuildContext {
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;
}
