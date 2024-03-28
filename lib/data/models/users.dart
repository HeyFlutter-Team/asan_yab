import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firebase_field_names.dart';

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
    this.invitationRate = 0,
  });

  Map<String, dynamic> toJson() => {
        FirebaseFieldNames.userName: name,
        FirebaseFieldNames.userLastName: lastName,
        FirebaseFieldNames.userEmail: email,
        FirebaseFieldNames.userCreatedAt: createdAt,
        FirebaseFieldNames.userImageUrl: imageUrl,
        FirebaseFieldNames.userType: userType,
        FirebaseFieldNames.userUid: uid,
        FirebaseFieldNames.userId: id,
        FirebaseFieldNames.userOwner: owner,
        FirebaseFieldNames.userOwnerPlaceName: ownerPlaceName,
        FirebaseFieldNames.userFollowerCount: followerCount,
        FirebaseFieldNames.userFollowingCount: followingCount,
        FirebaseFieldNames.userFcmToken: fcmToken,
        FirebaseFieldNames.userIsOnline: isOnline,
        FirebaseFieldNames.userInvitationRate: invitationRate
      };

  factory Users.fromMap(Map<String, dynamic> json) => Users(
      name: json[FirebaseFieldNames.userName],
      lastName: json[FirebaseFieldNames.userLastName],
      email: json[FirebaseFieldNames.userEmail],
      createdAt: json[FirebaseFieldNames.userCreatedAt] != null
          ? (json[FirebaseFieldNames.userCreatedAt] as Timestamp)
          : Timestamp.now(), // Ensure correct Timestamp conversion
      imageUrl: json[FirebaseFieldNames.userImageUrl],
      userType: json[FirebaseFieldNames.userType],
      uid: json[FirebaseFieldNames.userUid],
      id: json[FirebaseFieldNames.userId],
      owner: List<String>.from(json[FirebaseFieldNames.userOwner]),
      ownerPlaceName:
          List<String>.from(json[FirebaseFieldNames.userOwnerPlaceName]),
      followerCount: json[FirebaseFieldNames.userFollowerCount],
      followingCount: json[FirebaseFieldNames.userFollowingCount],
      fcmToken: json[FirebaseFieldNames.userFcmToken],
      isOnline: json[FirebaseFieldNames.userIsOnline] ?? false,
      invitationRate: json[FirebaseFieldNames.userInvitationRate]);
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
    int? invitationRate,
  }) =>
      Users(
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
        invitationRate: invitationRate ?? this.invitationRate,
      );
}
