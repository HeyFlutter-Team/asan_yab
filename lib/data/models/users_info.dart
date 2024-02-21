import 'package:cloud_firestore/cloud_firestore.dart';

class UsersInfo {
  final String name;
  final String imageUrl;
  final String uid;

  UsersInfo({required this.name, required this.imageUrl, required this.uid});

  factory UsersInfo.fromDocument(DocumentSnapshot doc) {
    return UsersInfo(
        name: doc['name'], imageUrl: doc['imageUrl'], uid: doc['uid']);
  }
}
