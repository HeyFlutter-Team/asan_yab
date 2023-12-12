import 'package:asan_yab/domain/riverpod/config/notification_repo.dart';
import 'package:asan_yab/presentation/pages/auth_page.dart';

import 'package:asan_yab/presentation/pages/main_page.dart';
import 'package:asan_yab/presentation/pages/profile_page.dart';
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
import 'domain/riverpod/data/verify_page_provider.dart';
import 'firebase_options.dart';
import 'presentation/pages/sign_in_page.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handler a background message ${message.notification} ');
  debugPrint('Title : ${message.notification!.title}');
  debugPrint('body : ${message.notification!.body}');
  debugPrint('PayLoad : ${message.data}');

  // BigTextStyleInformation bigPictureStyleInformation = BigTextStyleInformation(
  //     message.notification!.body.toString(),
  //     htmlFormatBigText: true,
  //     contentTitle: message.notification!.title.toString(),
  //     htmlFormatContentTitle: true);
  // AndroidNotificationDetails androidNotificationDetails =
  //     AndroidNotificationDetails('asan_yab', 'asan_yab',
  //         importance: Importance.high,
  //         styleInformation: bigPictureStyleInformation,
  //         priority: Priority.high,
  //         playSound: true);
  // NotificationDetails(android: androidNotificationDetails);
  // FlutterLocalNotificationsPlugin().show(0, message.notification?.title,
  //     message.notification?.body, platformChannelSpecifics,
  //     payload: message.data['id']);
}
final navigatorKey=GlobalKey<NavigatorState>();
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
    // TODO: implement initState
    if(FirebaseAuth.instance.currentUser != null){
      ref
          .read(internetConnectivityCheckerProvider.notifier)
          .startStremaing(context);
    }
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
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
      navigatorKey: navigatorKey,
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
      home:FutureBuilder<User?>(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder:(context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }else if(snapshot.hasError){
            return const Center(child: Text('خطا در اتصال'),);
          }
          else if(snapshot.hasData){
            return
            ref.watch(isEmailVerifieds)
                ?const MainPage()
                : VerifyEmailPage();

          }else{
            return const AuthPage();

          }
        }, )
    );
  }
}
