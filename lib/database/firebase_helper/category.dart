class CategoryData {
  final String? categoryName;
  final String? iconCode;
  final String? color;

  CategoryData({
    required this.categoryName,
    required this.iconCode,
    required this.color,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      categoryName: json['categoryName'],
      iconCode: json['iconCode'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryName': categoryName,
      'iconCode': iconCode,
      'color': color,
    };
  }
}
