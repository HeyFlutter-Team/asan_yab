import 'package:cloud_firestore/cloud_firestore.dart';

class UsersInfo {
  final String name;
  final String imageUrl;

  UsersInfo({required this.name, required this.imageUrl});

  factory UsersInfo.fromDocument(DocumentSnapshot doc) {
    return UsersInfo(
      name: doc['name'],
      imageUrl: doc['imageUrl'],
    );
  }
}
