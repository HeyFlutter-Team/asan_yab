import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final internetConnectivityCheckerProvider =
    StateNotifierProvider<InternetConnectivityChecker, bool>(
        (ref) => InternetConnectivityChecker(true));

class InternetConnectivityChecker extends StateNotifier<bool> {
  late ConnectivityResult connectivityResult;
  late StreamSubscription subscription;
  bool isConnected = true;

  InternetConnectivityChecker(super._state);

  void checkInternet(BuildContext context) async {
    connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none &&
        (isConnected == false)) {
      isConnected = true;
      isConnectedToNet();
      if (context.mounted) {
        showsSnackBarForConnect(context);
      }
    } else if (connectivityResult != ConnectivityResult.none) {
      isConnected = true;
      isConnectedToNet();
    } else {
      isConnected = false;
      isConnectedToNet();
      if (context.mounted) {
        showsSnackBarForDisconnect(context);
      }
    }
  }

  bool isConnectedToNet() => state = isConnected;
  void showsSnackBarForDisconnect(BuildContext context) {
    final snackBar = SnackBar(
      duration: const Duration(days: 1),
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
  }

  void showsSnackBarForConnect(BuildContext context) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 5),
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        message: 'از برنامه لذت ببرید!',
        contentType: ContentType.success,
        title: 'انترنت وصل است',
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void startStremaing(BuildContext context) {
    subscription = Connectivity().onConnectivityChanged.listen((event) {
      checkInternet(context);
    });
  }
}
