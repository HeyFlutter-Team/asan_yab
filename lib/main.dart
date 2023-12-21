import 'package:asan_yab/presentation/pages/auth_page.dart';
import 'package:asan_yab/presentation/pages/main_page.dart';
import 'package:asan_yab/presentation/pages/themeProvider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'domain/riverpod/config/internet_connectivity_checker.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
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
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      ref
          .read(internetConnectivityCheckerProvider.notifier)
          .startStremaing(context);
    }

    ref.read(themeModelProvider.notifier).initialize().whenComplete(
        () => ref.read(themeModelProvider.notifier).loadSavedTheme());

    // Listen for brightness changes
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
    final themeModel = ref.watch(themeModelProvider);
    return MaterialApp(
      navigatorKey: navigatorKey,
      themeMode: themeModel.currentThemeMode,
      darkTheme: ThemeData.dark().copyWith(
        textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'Shabnam',
              bodyColor: Colors.white,
            ),
      ),
      theme: ThemeData.light().copyWith(
        textTheme: ThemeData.light().textTheme.apply(
              fontFamily: 'Shabnam',
              bodyColor: Colors.black,
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
      ),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            brightness: Theme.of(context).brightness,
            // Add other theme configurations here if needed
          ),
          child: child!,
        );
      },
    );
  }
}
