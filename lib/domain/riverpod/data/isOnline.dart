import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IsOnline extends ChangeNotifier {
  Future<void> isOnlineToTrue() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        final token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          final userDoc = FirebaseFirestore.instance.collection('User').doc(currentUser.uid);
          final userData = await userDoc.get();
          final bool isOnline = userData.exists ? userData['isOnline'] : false;
          if (!isOnline) {
            await userDoc.update({'isOnline': true, 'fcmToken': token});
            notifyListeners();
          } else {
          }
        } else {
        }
      } catch (e) {
        print('');
      }
    } else {
    }
  }
}

final isOnlineUpdateProvider = ChangeNotifierProvider<IsOnline>((ref) => IsOnline());
