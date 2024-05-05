import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/riverpod/config/internet_connectivity_checker.dart';

class Utils{
  Utils._();
  static SnackBar lostNetSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 5),
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'انترنت وصل نیست!',
        message: 'لطفا انترنیت را وصل کنید!',
        contentType: ContentType.warning,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
    return snackBar;
  }
  static bool netIsConnected(WidgetRef ref){
    return  ref.watch(internetConnectivityCheckerProvider.notifier).isConnected;

  }
}