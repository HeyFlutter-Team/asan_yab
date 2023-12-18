import 'package:asan_yab/presentation/pages/detials_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../data/repositoris/local_rep/notification.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  // late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
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

    // debugPrint('tokken  token $token');
  }

  void getToken() async {
    final fcmToken = await _firebaseMessaging.getToken();
    token = fcmToken;
    NotificationUpdate().saveToken(token);
    // debugPrint('tokken  token $token');
  }

  void initInfo(BuildContext context) {
    const androidInitialize = AndroidInitializationSettings('asan_yab');
    const iOSInitialize = DarwinInitializationSettings();
    const initializationsSetting =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    FlutterLocalNotificationsPlugin().initialize(
      initializationsSetting,
      onDidReceiveNotificationResponse: (details) async {
        try {
          if (details.payload != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DetailsPage(id: details.payload.toString()),
                ));
          } else {}
        } catch (e) {}
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
}
