// this method is use to convert the farsi number to english number

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
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

void showsSnackBarForConnectAndDisconnect({
  required BuildContext context,
  required bool isConnected,
}) {
  final snackBar = SnackBar(
    duration: Duration(seconds: isConnected ? 5 : 2),
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      message: isConnected ? 'از برنامه لذت ببرید!' : 'انترنت وصل نیست!',
      contentType: isConnected ? ContentType.success : ContentType.warning,
      title: isConnected ? 'انترنت وصل است' : 'لطفا انترنیت را وصل کنید!',
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
