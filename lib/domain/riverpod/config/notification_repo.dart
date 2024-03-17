import 'package:asan_yab/data/repositoris/local_rep/notification.dart';
import 'package:asan_yab/main.dart';
import 'package:asan_yab/presentation/pages/detials_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// }

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
    debugPrint('tokken  token $token');
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

  Future<void> initialize(BuildContext context) async {
    // Request permission for receiving messages (for iOS)
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();
    print("User granted permission: ${settings.authorizationStatus}");

    // Handle messages when the app is in the background and opened by the user
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Background Message: ${message.notification?.title}");
      // Handle the message when the app is in the background

      _handleNotificationClick(message);
    });
  }

  void _handleNotificationClick(RemoteMessage message) {
    // Extract information from the message, e.g., route to navigate
    String? screenToNavigate = message.data['id'];

    if (screenToNavigate != null) {
      // Navigate to the desired screen
      navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) => DetailsPage(id: screenToNavigate),
      ));
    }
  }
}
