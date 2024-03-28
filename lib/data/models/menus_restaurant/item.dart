class Item {
  final String fName;
  final String fDescription;
  final String fPrice;
  final String fImage;

  Item(
      {required this.fName,
        required this.fDescription,
        required this.fPrice,
        required this.fImage});

  Map<String, dynamic> toJson() {
    return {
      'foodName': fName,
      'foodDescription': fDescription,
      'foodPrice': fPrice,
      "foodImageUrl": fImage
    };
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        fName: json['foodName'],
        fDescription: json['foodDescription'],
        fPrice: json['foodPrice'],
        fImage: json['foodImageUrl']);
  }
}
