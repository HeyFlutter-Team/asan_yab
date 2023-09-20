import 'package:cloud_firestore/cloud_firestore.dart';

class Place {
  final String id;
  final String logo;
  final String coverImage;
  final String? name;
  final String? description;
  final List<Address> adresses;
  final List<String> gallery;
  final String? category;
  final String categoryId;
  final Timestamp createdAt;
  int distance;

  Place({
    required this.categoryId,
    required this.category,
    required this.adresses,
    required this.id,
    required this.logo,
    required this.coverImage,
    required this.name,
    required this.description,
    required this.gallery,
    required this.createdAt,
    this.distance = 1,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
        createdAt: json['createdAt'],
        adresses: List<Address>.from(
            json['addresses'].map((address) => Address.fromJson(address))),
        id: json['id'],
        logo: json['logo'],
        coverImage: json['coverImage'],
        name: json['name'],
        description: json['description'],
        gallery: List<String>.from(json['gallery']),
        category: json['category'],
        categoryId: json['categoryId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'addresses': adresses.map((address) => address.toJson()).toList(),
      'id': id,
      'logo': logo,
      'coverImage': coverImage,
      'name': name,
      'description': description,
      'gallery': gallery,
      'category': category,
      'categoryId': categoryId
    };
  }
}

class Address {
  final String branch;
  final String address;
  final String lat;
  final String lang;
  final String phone;

  Address({
    required this.branch,
    required this.phone,
    required this.address,
    required this.lat,
    required this.lang,
  });

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'lat': lat,
      'lang': lang,
      'branch': branch,
      'phone': phone
    };
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
        branch: json['branch'],
        address: json['address'],
        lat: json['lat'],
        lang: json['lang'],
        phone: json['phone']);
  }
}
