import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firebase_field_names.dart';

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
  final List<ItemImage>? itemImages;
  final List<Doctors>? doctors;
  int distance;
  final List<NewProducts>? newItems;
  final List<NewItemsYounis>? newItemYounis;
  final List<String>? menuItemName;
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
    this.itemImages,
    this.doctors,
    this.newItems,
    this.newItemYounis,
    this.menuItemName
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    DateTime createdAt;

    if (json[FirebaseFieldNames.placeCreatedAt] == null) {
      throw Exception("Missing 'createdAt' field in JSON");
    }

    try {
      if (json[FirebaseFieldNames.placeCreatedAt] is Timestamp) {
        // If 'createdAt' is already a Timestamp
        createdAt =
            (json[FirebaseFieldNames.placeCreatedAt] as Timestamp).toDate();
      } else if (json[FirebaseFieldNames.placeCreatedAt]
          is Map<String, dynamic>) {
        // If 'createdAt' is a map with '_seconds' and '_nanoseconds'
        createdAt = DateTime.fromMillisecondsSinceEpoch(
          (json[FirebaseFieldNames.placeCreatedAt]['_seconds'] * 1000) +
              (json[FirebaseFieldNames.placeCreatedAt]['_nanoseconds'] / 1e6)
                  .round(),
        );
      } else {
        // Handle other cases or throw an error if necessary
        throw Exception(
            "Invalid 'createdAt' type: ${json[FirebaseFieldNames.placeCreatedAt].runtimeType}");
      }
    } catch (e) {
      throw Exception("Error parsing 'createdAt': $e");
    }

    return Place(
      createdAt: createdAt,
      addresses: List<Address>.from(
        json[FirebaseFieldNames.placeAddresses]
            .map((address) => Address.fromJson(address)),
      ),
      coverImage: json[FirebaseFieldNames.placeCoverImage],
      name: json[FirebaseFieldNames.placeName],
      description: json[FirebaseFieldNames.placeDescription],
      logo: json[FirebaseFieldNames.placeLogo],
      id: json[FirebaseFieldNames.placeId],
      categoryId: json[FirebaseFieldNames.placeCategoryId],
      gallery: List<String>.from(json[FirebaseFieldNames.placeGallery]),
      category: json[FirebaseFieldNames.placeCategory],
      order: json[FirebaseFieldNames.placeOrder],
      itemImages: json[FirebaseFieldNames.placeItemImages] != null
          ? List<ItemImage>.from(
              json[FirebaseFieldNames.placeItemImages]
                  .map((item) => ItemImage.fromJson(item)),
            )
          : null,
      doctors: json[FirebaseFieldNames.placeDoctors] != null
          ? List<Doctors>.from(
              json[FirebaseFieldNames.placeDoctors]
                  .map((doctors) => Doctors.fromJson(doctors)),
            )
          : null,
      newItems: json['newItems'] != null
          ? List<NewProducts>.from(
              json['newItems'].map((newItem) => NewProducts.fromJson(newItem)))
          : null,
      newItemYounis: json['newItemYounis'] != null
          ? List<NewItemsYounis>.from(json['newItemYounis']
              .map((newItemYounis) => NewProducts.fromJson(newItemYounis)))
          : null,
      menuItemName: json['menuItemName'] != null
          ? List<String>.from(json['menuItemName'])
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

  const Address({
    required this.address,
    required this.phone,
    required this.lang,
    required this.branch,
    required this.lat,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address: json[FirebaseFieldNames.address],
      phone: json[FirebaseFieldNames.addressPhone],
      lang: json[FirebaseFieldNames.addressLang],
      branch: json[FirebaseFieldNames.addressBranch],
      lat: json[FirebaseFieldNames.addressLat],
    );
  }
}

class NewProducts {
  final String? imageUrl;
  final String? name;
  final String? price;
  const NewProducts({
    this.imageUrl,
    this.name,
    this.price,
  });

  Map<String, dynamic> toJson() => {
        FirebaseFieldNames.newProductImage: imageUrl,
        FirebaseFieldNames.newProductName: name,
        FirebaseFieldNames.newProductPrice: price,
      };

  factory NewProducts.fromJson(Map<String, dynamic> json) => NewProducts(
        imageUrl: json[FirebaseFieldNames.newProductImage],
        name: json[FirebaseFieldNames.newProductName],
        price: json[FirebaseFieldNames.newProductPrice],
      );
}

class NewItemsYounis {
  final String? newItemYounisImage;
  final String? itemYounisName;
  final String? itemYounisPrice;

  const NewItemsYounis({
    this.newItemYounisImage,
    this.itemYounisName,
    this.itemYounisPrice,
  });

  factory NewItemsYounis.fromJson(Map<String, dynamic> json) => NewItemsYounis(
        newItemYounisImage: json['newItemYounis'],
        itemYounisName: json['itemYounisName'],
        itemYounisPrice: json['itemYounisPrice'],
      );

  Map<String, dynamic> toJson() {
    return {
      'newItemYounis': newItemYounisImage,
      'itemYounisName': itemYounisName,
      'itemYounisPrice': itemYounisPrice,
    };
  }
}

class ItemImage {
  final String name;
  final String price;
  final String imageUrl;

  const ItemImage({
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  factory ItemImage.fromJson(Map<String, dynamic> json) {
    return ItemImage(
      name: json['name'],
      price: json['price'],
      imageUrl: json['imageUrl'],
    );
  }
}

class Doctors {
  final String name;
  final String title;
  final String spendTime;
  final String imageUrl;

  const Doctors({
    required this.name,
    required this.title,
    required this.imageUrl,
    required this.spendTime,
  });

  Map<String, dynamic> toJson() => {
        FirebaseFieldNames.doctorName: name,
        FirebaseFieldNames.doctorTitle: title,
        FirebaseFieldNames.doctorImageUrl: imageUrl,
        FirebaseFieldNames.doctorSpendTime: spendTime,
      };

  factory Doctors.fromJson(Map<String, dynamic> json) => Doctors(
      name: json[FirebaseFieldNames.doctorName],
      title: json[FirebaseFieldNames.doctorTitle],
      imageUrl: json[FirebaseFieldNames.doctorImageUrl],
      spendTime: json[FirebaseFieldNames.doctorSpendTime]);
}

