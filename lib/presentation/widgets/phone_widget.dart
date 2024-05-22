import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../../core/utils/convert_digits_to_farsi.dart';

Widget buildPhoneNumberWidget(
    {required BuildContext context,
    required bool isRTL,
    required String phone,
    bool colorActive=false}) {
  return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 150,maxWidth: 160),
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8)),
          onPressed: () async {
            await FlutterPhoneDirectCaller.callNumber(phone);
          },
          child: isRTL
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      convertDigitsToFarsi(phone),
                      style: TextStyle(
                        fontSize: 16,
                        color:colorActive?Colors.white: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.phone_android_sharp,
                      color: Colors.green,
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.phone_android_sharp,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      phone,
                      style: TextStyle(
                        fontSize: 16,
                        color:colorActive?Colors.white: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                )));
}
