class Category {
  final String id;
  final String categoryName;
  final String iconCode;
  final String color;

  Category({
    required this.id,
    required this.categoryName,
    required this.iconCode,
    required this.color,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      categoryName: json['categoryName'],
      iconCode: json['iconCode'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryName': categoryName,
      'iconCode': iconCode,
      'color': color,
    };
  }
}
