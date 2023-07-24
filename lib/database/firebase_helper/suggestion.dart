class SuggestionFirebase {
  String id;
  String name;
  String address;
  String phone;
  String type;

  SuggestionFirebase({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.type,
  });

  factory SuggestionFirebase.fromJson(Map<String, dynamic> json) {
    return SuggestionFirebase(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'type': type,
    };
  }
}
