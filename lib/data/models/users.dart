import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final int id;
  final String uid;
  final String name;
  final String lastName;
  final String email;
  final Timestamp createdAt;
  final String imageUrl;
  final String userType;
  final List<String> owner;
  Users({
    this.owner = const ['s'],
    required this.id,
    required this.uid,
    this.imageUrl = '',
    this.userType = 'normal',
    required this.name,
    required this.lastName,
    required this.email,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'lastName': lastName,
        'email': email,
        'createdAt': createdAt,
        'imageUrl': imageUrl,
        'userType': userType,
        'uid': uid,
        'id': id,
        'owner': owner
      };

  factory Users.fromMap(Map<String, dynamic> json) {
    return Users(
      name: json['name'],
      lastName: json['lastName'],
      email: json['email'],
      createdAt: json['createdAt'],
      imageUrl: json['imageUrl'],
      userType: json['userType'],
      uid: json['uid'],
      id: json['id'],
      owner: List<String>.from(json['owner']),
    );
  }
}
