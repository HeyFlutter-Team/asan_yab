import 'dart:convert';
import 'dart:io';
import 'package:asan_yab/data/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';

class MessageNotification {
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;
  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();
  }

  static Future<void> sendPushNotificationMessage(Users chatUser, String msg,Users myData) async {
    try {
      final body = {
        'to': chatUser.fcmToken,
        'notification': {
          'title': myData.name,
          'body': msg,
          // 'sound': 'default',
          'android_channel_id': 'Chats',
          'visibility': 'public',
          'vibrate': [200, 100, 200],
        },
        "data": {
          "some_data" : "User ID: ${FirebaseAuth.instance.currentUser?.uid}",
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "image_url": "assets/asan_yab.jpg",
          "image": myData.imageUrl,
          "chat_page_id": myData.uid,
          "user_details": myData.toJson(),
        },
      };
      var res = await post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'key=AAAAej6YHuY:APA91bFEJmgUGauzfbR5Zrfd08P9TAWF8KPiext8YJutTeCY5DH465-Gv_csbgUjEbX37YY3iH9uGO-26YbiRoLKAKnUb6M1EpNpUuZopy4UCMaWZHDXmAz6M6EWyUD-bGZxlaWZCVYB', // Replace with your FCM server key
        },
        body: jsonEncode(body),
      );
      print('Response status code: ${res.statusCode}');
      print('Response body: ${res.body}');
      print('Response content length: ${res.contentLength}');
    } catch (e) {
      print('Mahdi: checking: error: $e');
    }
  }
}
