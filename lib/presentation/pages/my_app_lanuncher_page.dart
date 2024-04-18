import 'dart:ui';
import 'package:asan_yab/my_app.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositoris/language_repo.dart';
import '../../firebase_options.dart';

class MyAppLauncherPage {
  const MyAppLauncherPage();
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    debugPrint('Handling a background message ${message.data['id']}');
  }

  static Future<void> launchApp() async {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    WidgetsFlutterBinding.ensureInitialized();
    final container = ProviderContainer();
    final language =
        await container.read(languageRepositoryProvider).getLanguage();
    await Future.delayed(const Duration(seconds: 2));
    FlutterNativeSplash.remove();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseAnalytics.instance
        .setAnalyticsCollectionEnabled(true); //firebase analytics
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    //firebase messaging
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    runApp(ProviderScope(
      overrides: [languageProvider.overrideWith((ref) => language)],
      child: const MyApp(),
    ));
  }
}
