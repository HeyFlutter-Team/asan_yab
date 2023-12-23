import 'package:cloud_firestore/cloud_firestore.dart';

class Users{
  final int id;
  final String uid;
  final String name;
  final String lastName;
  final String email;
  final Timestamp createdAt;
  final String imageUrl;
  final String userType;
  final List<String>? owner;
  final List<String>? ownerPlaceName;
  Users({
    this.ownerPlaceName,
    this.owner,
    required this.id,
    required this.uid,
    this.imageUrl='',
    this.userType='normal',
   required this.name,
   required this.lastName,
   required this.email,
   required this.createdAt

  });

   
  Map<String,dynamic> toJson()=>{
    'name':name,
    'lastName':lastName,
    'email':email,
    'createdAt':createdAt,
    'imageUrl':imageUrl,
    'userType':userType,
    'uid':uid,
    'id':id,
    'owner':owner,
    'ownerPlaceName':ownerPlaceName

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
        owner: json['owner'],
      ownerPlaceName: json['ownerPlaceName']
    );
  }
}