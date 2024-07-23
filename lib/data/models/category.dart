
class Category{
  final String id;
  final String name;
  final String numberOfPlaces;
  final String iconCode;
  final String color;
  final String enName;

  const Category({
    required this.id,
    required this.name,
    required this.numberOfPlaces,
    required this.iconCode,
    required this.color,
    required this.enName,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      numberOfPlaces: json['numberOfPlaces'],
      iconCode: json['iconCode'],
      color: json['color'],
      enName: json['enName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'numberOfPlaces': numberOfPlaces,
      'iconCode': iconCode,
      'color': color,
      'enName': enName,
    };
    return data;
  }
}