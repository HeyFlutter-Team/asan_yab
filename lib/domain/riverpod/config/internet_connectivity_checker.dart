import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/convert_digits_to_farsi.dart';

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

  void startStreaming(BuildContext context) {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((event) => checkInternet(context));
  }
}
