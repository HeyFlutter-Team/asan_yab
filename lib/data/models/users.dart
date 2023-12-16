import 'package:cloud_firestore/cloud_firestore.dart';

class Users{
  final String name;
  final String lastName;
  final String email;
  final Timestamp createdAt;
  final String imageUrl;
  Users({
    this.imageUrl='',
   required this.name,
   required this.lastName,
   required this.email,
   required this.createdAt});

   
  Map<String,dynamic> toJson()=>{
    'name':name,
    'lastName':lastName,
    'email':email,
    'createdAt':createdAt,
    'imageUrl':imageUrl
  };

  factory Users.fromMap(Map<String, dynamic> json) {
    return Users(
      name: json['name']??'',
      lastName: json['lastName']??'',
      email: json['email']??'',
      createdAt: json['createdAt']??'',
      imageUrl: json['imageUrl'],
    );
  }
}