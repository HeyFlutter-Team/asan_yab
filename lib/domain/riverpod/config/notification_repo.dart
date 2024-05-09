import 'dart:convert';
import 'package:asan_yab/data/models/message/message.dart';
import 'package:asan_yab/data/repositoris/local_rep/notification.dart';
import 'package:asan_yab/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/users.dart';
import '../../../presentation/pages/message_page/chat_details_page.dart';
import '../data/message/message.dart';
import '../data/message/message_data.dart';
import '../data/other_user_data.dart';
import '../screen/botton_navigation_provider.dart';


class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  // late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  String? token = '';

  void getToken() async {
    final fcmToken = await _firebaseMessaging.getToken();
    token = fcmToken;
    NotificationUpdate().saveToken(token);
    debugPrint('tokken  token $token');
  }

  Future<void> initInfo(WidgetRef ref) async {
    const androidInitialize = AndroidInitializationSettings('asan_yab');
    const iOSInitialize =
    DarwinInitializationSettings(defaultPresentBanner: true);
    const initializationsSetting = InitializationSettings(
        android: androidInitialize, iOS: iOSInitialize);
    FlutterLocalNotificationsPlugin().initialize(
      initializationsSetting,
      onDidReceiveNotificationResponse: (details) async {

      debugPrint(' id ${details.id}');
      debugPrint('playyyyyyy load ${details.payload}');

      try {
        Map<String, dynamic> payloadData =
        json.decode(details.payload.toString());
        String? userDetailsJson = payloadData['user_details'];
        print('User Details JSON: $userDetailsJson');

        Map<String, dynamic> userDetailsMap = json.decode(userDetailsJson!);

        Users userDetails = Users.fromMap(userDetailsMap);
        print('User Details: $userDetails');
        if(navigatorKey.currentState?.canPop() == true) {
          WidgetsBinding.instance.addPostFrameCallback((_) async{
          print('test 1');
          navigatorKey.currentState?.pop();
          print('test 2');
          ref
              .read(buttonNavigationProvider.notifier)
              .selectedIndex(2);
          ref.read(messageProvider.notifier).clearState();
          ref.read(otherUserProvider.notifier).setDataUser(userDetails);
          print('test 4');
          await Future.delayed(const Duration(seconds: 1)).whenComplete(() {
            print('test 3');

            print('test 5');
          }
          ).whenComplete(() =>
              navigatorKey.currentState?.push(MaterialPageRoute(
                builder: (context) =>
                    ChatDetailPage(
                      uid: userDetails.uid,
                    ),
              )));

          print('test 6');
        });
        }else{

          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref
                .read(buttonNavigationProvider.notifier)
                .selectedIndex(2);
            ref.read(messageProvider.notifier).clearState();
            ref.read(otherUserProvider.notifier).setDataUser(userDetails);
            navigatorKey.currentState?.push(MaterialPageRoute(
              builder: (context) =>
                  ChatDetailPage(
                    uid: userDetails.uid,
                  ),
            ));
          });
        }


      } catch (e) {
        print('Error decoding user_details: $e');
      }


      },
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      String? chatId = message.data['chat_page_id'];
      print('youuuuuuuuuuuuuuuunisssssssssssssssssssdisposssssssseeeeeeedddddd');
      print(chatId);
      print(ref.watch(activeChatIdProvider));
      if(ref.context.mounted) {
        if (chatId != ref.watch(activeChatIdProvider)) {
          BigTextStyleInformation bigPictureStyleInformation =
          BigTextStyleInformation('${message.notification?.body.toString()}joooo',
              htmlFormatBigText: true,
              contentTitle: '${message.notification?.title.toString()}',
              htmlFormatContentTitle: true);
          AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails('asan_yab', 'asan_yab',
              importance: Importance.high,
              styleInformation: bigPictureStyleInformation,
              priority: Priority.high,
              // playSound: true
          );
          NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidNotificationDetails);
          FlutterLocalNotificationsPlugin().show(0,
              message.notification?.title,
              '${message.notification?.body}'.isNotEmpty?message.notification?.body:'Gif',
              platformChannelSpecifics,
              payload:jsonEncode(message.data)
          );
        }
      }
    });

  }
  Future<void> initialize(BuildContext context,WidgetRef ref) async {
    // Request permission for receiving messages (for iOS)
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission(
          sound: true,
          alert: true,
          badge: true
        );
    print("User granted permission: ${settings.authorizationStatus}");

    // Handle messages when the app is in the background and opened by the user
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Background Message: ${message.notification?.title}");
      // Handle the message when the app is in the background


      _handleNotificationClick(message,ref);
    });
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );
  }

  void _handleNotificationClick(RemoteMessage message, WidgetRef ref) {
    print('joooooooooooooooooooooooooooooooooo dege');
    String? chatToNavigate = message.data['chat_page_id'];
    String? userDetailsJson = message.data['user_details'];
    String? myUid = message.data['some_data'];
    print('_handleNotificationClick');
    print('userDetailsJson: $userDetailsJson');
    print('some data $myUid');
    print('chat page id $chatToNavigate');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        print('userDetailsJson length: ${userDetailsJson?.length}');
        Map<String, dynamic> userDetailsMap = json.decode(userDetailsJson!);
        Users userDetails = Users.fromMap(userDetailsMap);
        ref.read(messageProvider.notifier).clearState();
        ref.read(otherUserProvider.notifier).setDataUser(userDetails);
        if( navigatorKey.currentState?.canPop()==true){
          navigatorKey.currentState?.pop();
        }
        ref
            .read(buttonNavigationProvider.notifier)
            .selectedIndex(2);
        navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (context) => ChatDetailPage(
            uid: userDetails.uid,
          ),
        ));
      } catch (e) {
        print('Error decoding userDetailsJson: $e');
    }
    });
  }
}
