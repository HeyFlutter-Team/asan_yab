import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/convert_digits_to_farsi.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'check_internet_connectivity.g.dart';

@riverpod
class CheckInternetConnectivity extends _$CheckInternetConnectivity {
  late ConnectivityResult connectivityResult;
  late StreamSubscription subscription;
  bool isConnected = true;
  @override
  bool build() => true;
  void checkInternet(BuildContext context) async {
    connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none &&
        (isConnected == false)) {
      isConnected = true;
      isConnectedToNet();
      if (context.mounted) {
        showsSnackBarForConnectAndDisconnect(
            context: context, isConnected: true);
      }
    } else if (connectivityResult != ConnectivityResult.none) {
      isConnected = true;
      isConnectedToNet();
    } else {
      isConnected = false;
      isConnectedToNet();
      if (context.mounted) {
        showsSnackBarForConnectAndDisconnect(
            context: context, isConnected: false);
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
