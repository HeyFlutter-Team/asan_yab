import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final int id;
  final String? uid;
  late final String name;
  final String lastName;
  final String email;
  final Timestamp createdAt;
  final String imageUrl;
  final String userType;
  final List<String> owner;
  final List<String> ownerPlaceName;
  final int invitationRate;
  final int followerCount;
  final int followingCount;
  final String fcmToken;
  final bool isOnline;

  Users({
    this.owner = const [],
    this.ownerPlaceName = const [],
    required this.id,
    this.uid,
    this.imageUrl = '',
    this.userType = 'normal',
    required this.name,
    required this.lastName,
    required this.email,
    required this.createdAt,
    this.followerCount = 0,
    this.followingCount = 0,
    required this.fcmToken,
    required this.isOnline,
    this.invitationRate = 0
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
        'owner': owner,
        'ownerPlaceName': ownerPlaceName,
        'followerCount': followerCount,
        'followingCount': followingCount,
        'fcmToken': fcmToken,
        'isOnline': isOnline,
        'invitationRate':invitationRate
      };

  factory Users.fromMap(Map<String, dynamic> json) {
    return Users(
        name: json['name'],
        lastName: json['lastName'],
        email: json['email'],
        createdAt: json['createdAt'] != null
            ? (json['createdAt'] as Timestamp)
            : Timestamp.now(), // Ensure correct Timestamp conversion
        imageUrl: json['imageUrl'],
        userType: json['userType'],
        uid: json['uid'],
        id: json['id'],
        owner: List<String>.from(json['owner']),
        ownerPlaceName: List<String>.from(json['ownerPlaceName']),
        followerCount: json['followerCount'],
        followingCount: json['followingCount'],
        fcmToken: json['fcmToken'],
        isOnline: json['isOnline'] ?? false,
        invitationRate: json['invitationRate']
    );

  }
  Users copyWith({
    int? id,
    String? uid,
    String? name,
    String? lastName,
    String? email,
    Timestamp? createdAt,
    String? imageUrl,
    String? userType,
    List<String>? owner,
    List<String>? ownerPlaceName,
    int? followerCount,
    int? followingCount,
    String? fcmToken,
    bool? isOnline,
    int? invitationRate
  }) {
    return Users(
        id: id ?? this.id,
        uid: uid ?? this.uid,
        name: name ?? this.name,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        createdAt: createdAt ?? this.createdAt,
        imageUrl: imageUrl ?? this.imageUrl,
        userType: userType ?? this.userType,
        owner: owner ?? this.owner,
        ownerPlaceName: ownerPlaceName ?? this.ownerPlaceName,
        followerCount: followerCount ?? this.followerCount,
        followingCount: followingCount ?? this.followingCount,
        fcmToken: fcmToken ?? this.fcmToken,
        isOnline: isOnline ?? this.isOnline,
        invitationRate: invitationRate??this.invitationRate
    );
  }
}
