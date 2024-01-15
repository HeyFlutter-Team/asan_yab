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
  final List<NewItems>? newItems;
  final List<NewItemsYounis>? newItemYounis;
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
    this.distance = 1,
    this.newItems,
    this.newItemYounis,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    DateTime createdAt;

    if (json['createdAt'] == null) {
      throw Exception("Missing 'createdAt' field in JSON");
    }

    try {
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
        throw Exception(
            "Invalid 'createdAt' type: ${json['createdAt'].runtimeType}");
      }
    } catch (e) {
      throw Exception("Error parsing 'createdAt': $e");
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
      newItems: json['newItems'] != null
          ? List<NewItems>.from(
              json['newItems'].map((newItem) => NewItems.fromJson(newItem)))
          : null,
      newItemYounis: json['newItemYounis'] != null
          ? List<NewItemsYounis>.from(json['newItemYounis']
              .map((newItemYounis) => NewItems.fromJson(newItemYounis)))
          : null,
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

class NewItems {
  final String? imageUrl;
  final String? itemName;
  final String? itemPrice;
  NewItems({this.imageUrl, this.itemName, this.itemPrice});

  Map<String, dynamic> toJson() {
    return {'imageUrl': imageUrl, 'itemName': itemName, 'itemPrice': itemPrice};
  }

  factory NewItems.fromJson(Map<String, dynamic> json) {
    return NewItems(
        imageUrl: json['imageUrl'],
        itemName: json['itemName'],
        itemPrice: json['itemPrice']);
  }
}

class NewItemsYounis {
  final String? newItemYounisImage;
  final String? itemYounisName;
  final String? itemYounisPrice;

  NewItemsYounis({
    this.newItemYounisImage,
    this.itemYounisName,
    this.itemYounisPrice,
  });

  factory NewItemsYounis.fromJson(Map<String, dynamic> json) {
    return NewItemsYounis(
      newItemYounisImage: json['newItemYounis'],
      itemYounisName: json['itemYounisName'],
      itemYounisPrice: json['itemYounisPrice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'newItemYounis': newItemYounisImage,
      'itemYounisName': itemYounisName,
      'itemYounisPrice': itemYounisPrice,
    };
  }
}
