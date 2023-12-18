import 'package:asan_yab/domain/riverpod/config/notification_repo.dart';
import 'package:asan_yab/presentation/pages/main_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
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
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

var themeMode = ThemeMode.system;
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

Future<void> main() async {
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
  runApp(const ProviderScope(child: MyApp())
      // DevicePreview(
      //   enabled: !kReleaseMode,
      //   builder: (context) =>
      //       const ProviderScope(child: MyApp()), // Wrap your app
      // ),
      );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
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
  Widget build(BuildContext context) {
    FirebaseApi().initInfo(context);
    FirebaseApi().getToken();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(),
      child: MaterialApp(
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
        useInheritedMediaQuery: true,
        // locale: DevicePreview.locale(context),
        // builder: DevicePreview.appBuilder,
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
        // theme: ThemeData(
        //   fontFamily: 'Shabnam',
        // ),

        home: const MainPage(),
      ),
    );
  }
}
