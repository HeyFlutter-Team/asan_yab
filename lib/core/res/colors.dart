

import 'package:flutter/cupertino.dart';

const  primaryColor = Color(0xFFffffff);
const  secondaryColor = Color(0xff348781);
const  textColor = Color(0xFFb3b3b3);

Color tempName({required String tempColor}) {
  return Color(int.parse((tempColor.replaceAll('#', '0xff'))))
      .withOpacity(0.6);
}