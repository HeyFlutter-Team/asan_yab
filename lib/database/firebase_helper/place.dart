class Place {
  final String id;
  final String? logo;
  final String? coverImage;
  final String? name;
  final String? description;
  final List<String> phoneNumbers;
  final List<Address> adresses;
  final List<String?> gallery;
  

  Place({

    required this.id,
    required this.logo,
    required this.coverImage,
    required this.name,
    required this.description,
    required this.phoneNumbers,
    required this.gallery,
    required this.adresses,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
        adresses:List<Address>.from(json['addresses'].map((address) => Address.fromJson(address))),
        id: json['id'],
        logo: json['logo'],
        coverImage: json['coverImage'],
        name: json['name'],
        description: json['description'],
        phoneNumbers: List<String>.from(json['phoneNumbers']),
        gallery: List<String>.from(json['gallery']),
        );
  }

  Map<String, dynamic> toJson() {
    return {
      'addresses':adresses.map((address) => address.toJson()).toList(),
      'id': id,
      'logo': logo,
      'coverImage': coverImage,
      'name': name,
      'description': description,
      'phoneNumbers': phoneNumbers,
      'gallery': gallery,
      
    };
  }
}



class Address {
 final String address;
 final String lat;
 final String lang;

  Address({
    required this.address,
    required this.lat,
    required this.lang,
  });

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'lat': lat,
      'lang': lang,
    };
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address: json['address'],
      lat: json['lat'],
      lang: json['lang'],
    );
  }
}