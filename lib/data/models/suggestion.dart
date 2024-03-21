class SuggestionFirebase {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String type;

  const SuggestionFirebase({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.type,
  });

  factory SuggestionFirebase.fromJson(Map<String, dynamic> json) =>
      SuggestionFirebase(
        id: json['id'],
        name: json['name'],
        address: json['address'],
        phone: json['phone'],
        type: json['type'],
      );

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
