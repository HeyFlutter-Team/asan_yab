import 'package:asan_yab/data/repositoris/local_rep/update_notification.dart';
import 'package:asan_yab/presentation/pages/detials_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../core/routes/route_config.dart';

// }

class NotificationRepo {
  NotificationRepo();
  final _firebaseMessaging = FirebaseMessaging.instance;
  String? token = '';
  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  void getToken() async {
    final fcmToken = await _firebaseMessaging.getToken();
    token = fcmToken;
    UpdateNotification().saveToken(token);
    debugPrint('tokKen  token $token');
  }

  void initInfo() {
    const androidInitialize = AndroidInitializationSettings('asan_yab');
    const iOSInitialize =
        DarwinInitializationSettings(defaultPresentBanner: true);
    const initializationsSetting =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    FlutterLocalNotificationsPlugin().initialize(
      initializationsSetting,
      onDidReceiveNotificationResponse: (details) async {
        try {
          debugPrint(' id ${details.id}');
          debugPrint('playyy load ${details.payload}');
          if (details.payload != null) {
            navigatorKey.currentState?.push(MaterialPageRoute(
              builder: (context) =>
                  DetailsPage(id: details.payload!.toString()),
            ));
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      },
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('.............onMessage.............');
      debugPrint(
          'onMessage: ${message.notification?.title}/${message.notification?.body}');

      BigTextStyleInformation bigPictureStyleInformation =
          BigTextStyleInformation(message.notification!.body.toString(),
              htmlFormatBigText: true,
              contentTitle: message.notification!.title.toString(),
              htmlFormatContentTitle: true);
      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails('asan_yab', 'asan_yab',
              importance: Importance.high,
              styleInformation: bigPictureStyleInformation,
              priority: Priority.high,
              playSound: true);
      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidNotificationDetails);
      FlutterLocalNotificationsPlugin().show(0, message.notification?.title,
          message.notification?.body, platformChannelSpecifics,
          payload: message.data['id']);
    });
  }

  Future<void> initialize(BuildContext context) async {
    final settings = await _firebaseMessaging.requestPermission();
    debugPrint("User granted permission: ${settings.authorizationStatus}");

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("Background Message: ${message.notification?.title}");

      _handleNotificationClick(message);
    });

    String? token = await _firebaseMessaging.getToken();
    debugPrint("FCM Token: $token");
  }

  void _handleNotificationClick(RemoteMessage message) {
    String? screenToNavigate = message.data['id'];

    if (screenToNavigate != null) {
      navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) => DetailsPage(id: screenToNavigate),
      ));
    }
  }
}
