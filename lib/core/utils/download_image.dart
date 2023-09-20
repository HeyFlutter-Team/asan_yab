import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DownloadImage {
  DownloadImage._();
  static Int8List logo = Int8List(0);
  static Int8List coverImage = Int8List(0);

  static Future<Int8List> downloadFile(String url) async {
    final bytes = (await NetworkAssetBundle(Uri.parse(url)).load(url))
        .buffer
        .asInt8List();
    return bytes;
  }

  static Future<void> getImage(
      String urlLogo, String coverImage1, BuildContext context) async {
    showDialogBox(context);
    logo = await downloadFile(urlLogo);
    coverImage = await downloadFile(coverImage1);
  }

  static void showDialogBox(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => SizedBox(
              height: 100,
              child: AlertDialog(
                elevation: 4,
                content: const Row(
                  children: [
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                          color: Colors.blueGrey, strokeWidth: 3.0),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'لطفا صبر کنید...',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.circular(12)),
                // title: const Text('لطفا صبر کنید!'),
                // content: const Text('لطفآ به انترنیت وصل شوید؟'),
              ),
            ));
  }
}
