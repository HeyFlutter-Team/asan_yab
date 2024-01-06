import 'package:cloud_firestore/cloud_firestore.dart';

class Place {
  final DateTime createdAt;
  final List<Address> addresses;
  final String coverImage;
  final String name;
  final String description;
  final String logo;
  final String id;
  final String categoryId;
  final List<String> gallery;
  final String category;
  final int order;
 int distance;
  Place({
    required this.createdAt,
    required this.addresses,
    required this.coverImage,
    required this.name,
    required this.description,
    required this.logo,
    required this.id,
    required this.categoryId,
    required this.gallery,
    required this.category,
    required this.order,
     this.distance =1,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    DateTime createdAt;

    if (json['createdAt'] is Timestamp) {
      // If 'createdAt' is already a Timestamp
      createdAt = (json['createdAt'] as Timestamp).toDate();
    } else if (json['createdAt'] is Map<String, dynamic>) {
      // If 'createdAt' is a map with '_seconds' and '_nanoseconds'
      createdAt = DateTime.fromMillisecondsSinceEpoch(
        (json['createdAt']['_seconds'] * 1000) +
            (json['createdAt']['_nanoseconds'] / 1e6).round(),
      );
    } else {
      // Handle other cases or throw an error if necessary
      throw Exception("Invalid 'createdAt' type");
    }

    return Place(
      createdAt: createdAt,
      addresses: List<Address>.from(
        json['addresses'].map((address) => Address.fromJson(address)),
      ),
      coverImage: json['coverImage'],
      name: json['name'],
      description: json['description'],
      logo: json['logo'],
      id: json['id'],
      categoryId: json['categoryId'],
      gallery: List<String>.from(json['gallery']),
      category: json['category'],
      order: json['order'],
    );
  }
}

class Address {
  final String address;
  final String phone;
  final String lang;
  final String branch;
  final String lat;

  Address({
    required this.address,
    required this.phone,
    required this.lang,
    required this.branch,
    required this.lat,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address: json['address'],
      phone: json['phone'],
      lang: json['lang'],
      branch: json['branch'],
      lat: json['lat'],
    );
  }
}
