import 'package:asan_yab/domain/riverpod/config/notification_repo.dart';
import 'package:asan_yab/presentation/pages/auth_page.dart';
import 'package:asan_yab/presentation/pages/main_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'domain/riverpod/config/internet_connectivity_checker.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
var themeMode = ThemeMode.system;
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.data['id']}');
}

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
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
  //firebase messegaing

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      ref
          .read(internetConnectivityCheckerProvider.notifier)
          .startStremaing(context);
    }
    super.initState();
    SystemChannels.platform.invokeMethod<void>(
        'SystemChrome.setPreferredOrientations', <String, dynamic>{
      'preferredOrientations': <String>['portraitUp', 'portraitDown'],
    });
    // Listen for brightness changes
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      SchedulerBinding.instance?.addPersistentFrameCallback((_) {
        final Brightness brightness =
            SchedulerBinding.instance!.window.platformBrightness;
        final ThemeMode newThemeMode =
            brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;

        if (newThemeMode != themeMode) {
          setState(() {
            themeMode = newThemeMode;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    if (FirebaseAuth.instance.currentUser != null) {
      ref
          .read(internetConnectivityCheckerProvider.notifier)
          .subscription
          .cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
        themeMode: themeMode,
        darkTheme: ThemeData.dark().copyWith(
          textTheme: ThemeData.dark().textTheme.apply(
                fontFamily: 'Shabnam',
                bodyColor: Colors.white, // Set text color for dark mode
              ),
        ),
        theme: ThemeData.light().copyWith(
          textTheme: ThemeData.light().textTheme.apply(
                fontFamily: 'Shabnam',
                bodyColor: Colors.black,
                // Set text color for dark mode
              ),
        ),
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
        ],
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('fa')],
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('خطا در اتصال'),
              );
            } else if (snapshot.hasData) {
              return MainPage();
              // VerifyEmailPage();
            } else {
              return const AuthPage();
            }
          },
        ));
  }
}
