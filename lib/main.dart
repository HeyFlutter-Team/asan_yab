import 'package:asan_yab/presentation/pages/auth_page.dart';
import 'package:asan_yab/presentation/pages/main_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'domain/riverpod/config/internet_connectivity_checker.dart';
import 'domain/riverpod/data/language_controller_provider.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.data['id']}');
}

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  await Future.delayed(const Duration(seconds: 2));
  FlutterNativeSplash.remove();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final savedLocale = prefs.getString('appLocale');
  await EasyLocalization.ensureInitialized();


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

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('fa', 'AF')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      startLocale:savedLocale != null
          ? Locale(savedLocale.split('_')[0], savedLocale.split('_')[1])
          : null,
      saveLocale: true,
      child: ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // @override
  // void initState() {
  //   if (FirebaseAuth.instance.currentUser != null) {
  //     ref
  //         .read(internetConnectivityCheckerProvider.notifier)
  //         .startStremaing(context);
  //   }
  //   super.initState();
  // }
  //
  // @override
  // void dispose() {
  //   if (FirebaseAuth.instance.currentUser != null) {
  //     ref
  //         .read(internetConnectivityCheckerProvider.notifier)
  //         .subscription
  //         .cancel();
  //   }
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      navigatorKey: navigatorKey,
      useInheritedMediaQuery: true,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Shabnam',
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
      ),
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
            return const MainPage();
            // VerifyEmailPage();
          } else {
            return const AuthPage();
          }
        },
      ),
    );
  }
}
