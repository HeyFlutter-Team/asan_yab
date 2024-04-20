import 'package:flutter/cupertino.dart';

const kPrimaryColor = Color(0xFFffffff);
const kSecondaryColor = Color(0xff348781);
const kTextColor = Color(0xFFb3b3b3);

Color tempName({required String tempColor}) {
  final colorCode = tempColor.replaceAll('#', '0xff');
  final color = int.parse(colorCode);
  return Color(color).withOpacity(0.6);
}
