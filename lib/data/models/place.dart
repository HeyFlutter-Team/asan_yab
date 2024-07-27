import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place {
  final String id;
  final ImageModel logo;
  final ImageModel coverImage;
  final String name;
  final String? description;
  final List<Address> addresses;
  final List<ImageModel> gallery;
  final String category;
  final String categoryId;
  final Timestamp createdAt;
  final int order;
  final List<NewItems> items;
  final List<Doctors> doctors;
  int distance;


   Place(
      {required this.categoryId,
        required this.category,
        required this.addresses,
        required this.id,
        required this.logo,
        required this.coverImage,
        required this.name,
        required this.description,
        required this.gallery,
        required this.createdAt,
        required this.order,
        required this.items,
        this.distance = 1,
        required this.doctors});
  Place copyWith({
    String? id,
    ImageModel? logo,
    ImageModel? coverImage,
    String? name,
    String? description,
    List<Address>? addresses,
    List<ImageModel>? gallery,
    String? category,
    String? categoryId,
    Timestamp? createdAt,
    int? order,
    List<NewItems>? items,
    List<Doctors>? doctors,
  }) {
    return Place(
      id: id ?? this.id,
      logo: logo ?? this.logo,
      coverImage: coverImage ?? this.coverImage,
      name: name ?? this.name,
      description: description ?? this.description,
      addresses: addresses ?? this.addresses,
      gallery: gallery ?? this.gallery,
      category: category ?? this.category,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      order: order ?? this.order,
      items: items ?? this.items,
      doctors: doctors ?? this.doctors,
    );
  }

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      createdAt: json['createdAt'],
      addresses: List<Address>.from(
        json['addresses'].map((address) => Address.fromJson(address)),
      ),
      id: json['id'],
      logo: ImageModel.fromJson(json['logo']),
      coverImage: ImageModel.fromJson(json['coverImage']),
      name: json['name'],
      description: json['description'],
      gallery: (json['gallery'] as List<dynamic>)
          .map((url) => ImageModel(url: url))
          .toList(),
      category: json['category'],
      categoryId: json['categoryId'],
      order: json['order'],
      items: List<NewItems>.from(
          json['itemImages'].map((item) => NewItems.fromJson(item))),
      doctors: List<Doctors>.from(
          json['doctors'].map((doctor) => Doctors.fromJson(doctor))),
    );
  }
}
class Address {
  final String? id;
  final String branch;
  final String address;
  final LatLng? latLng;
  final String phone;

  Address({
    required this.id,
    required this.branch,
    required this.phone,
    required this.address,
    required this.latLng,
  });
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
        id: json['id'],
        branch: json['branch'],
        address: json['address'],
        latLng: LatLng.fromJson(json['latlng']),
        phone: json['phone']);
  }

}

class NewItems {
  final String id;
  final String name;
  final String price;
  final ImageModel image;

  NewItems({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': image,
    };
  }

  factory NewItems.fromJson(Map<String, dynamic> json) {
    return NewItems(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      image: json['imageUrl'],
    );
  }
}
class ImageModel {
  bool isLoading;
  String? url;
  static const defaultImage = 'https://via.placeholder.com/150';

  ImageModel({
    this.isLoading = false,
    required this.url,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      isLoading: json['isLoading'] ?? false,
      url: json['url'],
    );
  }
}



class Doctors {
  final String id;
  final String name;
  final String specialist;
  final WorkTimeModel time;
  final ImageModel image;

  Doctors(
      {required this.id,
        required this.name,
        required this.specialist,
        required this.image,
        required this.time});

  factory Doctors.fromJson(Map<String, dynamic> json) {
    return Doctors(
        id: json['id'],
        name: json['name'],
        specialist: json['title'],
        image: ImageModel.fromJson(json['image']),
        time: WorkTimeModel.fromJson(json['time']));
  }

  Doctors copyWith({
    final String? id,
    final String? name,
    final String? specialist,
    final WorkTimeModel? time,
    final ImageModel? image,
  }) {
    return Doctors(
      id: id ?? this.id,
      name: name ?? this.name,
      specialist: specialist ?? this.specialist,
      time: time ?? this.time,
      image: image ?? this.image,
    );
  }
}


class WorkTimeModel {
  final String startTime;
  final String endTime;

  WorkTimeModel({
    required this.startTime,
    required this.endTime,
  });

  factory WorkTimeModel.fromJson(Map<String, dynamic> json) {
    return WorkTimeModel(
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  WorkTimeModel copyWith({
    String? startTime,
    String? endTime,
  }) {
    return WorkTimeModel(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
