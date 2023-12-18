import 'package:asan_yab/domain/riverpod/config/notification_repo.dart';
import 'package:asan_yab/presentation/pages/auth_page.dart';

import 'package:asan_yab/presentation/pages/main_page.dart';

import 'package:asan_yab/presentation/pages/verify_email_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'domain/riverpod/config/internet_connectivity_checker.dart';
import 'firebase_options.dart';


Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handler a background message ${message.notification} ');
  debugPrint('Title : ${message.notification!.title}');
  debugPrint('body : ${message.notification!.body}');
  debugPrint('PayLoad : ${message.data}');
}
Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
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
  await FirebaseApi().initNotification();
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
    if(FirebaseAuth.instance.currentUser != null){
      ref
          .read(internetConnectivityCheckerProvider.notifier)
          .startStremaing(context);
    }
    super.initState();

  }
  @override
  void dispose() {
    if(FirebaseAuth.instance.currentUser != null){
      ref
          .read(internetConnectivityCheckerProvider.notifier)
          .subscription
          .cancel();
    }
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    FirebaseApi().initInfo(context);
    FirebaseApi().getToken();

    return MaterialApp(
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
      theme: ThemeData(
        fontFamily: 'Shabnam',
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
      ),
      home:StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder:(context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }else if(snapshot.hasError){
            return const Center(child: Text('خطا در اتصال'),);
          }
          else if(snapshot.hasData){
            return  const MainPage();
          }else{
            return const AuthPage();

          }
        }, )
    );
  }
}
