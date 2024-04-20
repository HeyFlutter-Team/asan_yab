import 'package:asan_yab/core/constants/firebase_field_names.dart';

class Category {
  final String id;
  final String name;
  final String iconCode;
  final String color;
  final String? enCategoryName;

  const Category({
    required this.id,
    required this.name,
    required this.iconCode,
    required this.color,
    this.enCategoryName,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
      id: json[FirebaseFieldNames.categoryId],
      name: json[FirebaseFieldNames.categoryName],
      iconCode: json[FirebaseFieldNames.categoryIconCode],
      color: json[FirebaseFieldNames.categoryColor],
      enCategoryName: json[FirebaseFieldNames.enCategoryName] ?? '');

  Map<String, dynamic> toJson() => {
        FirebaseFieldNames.categoryId: id,
        FirebaseFieldNames.categoryName: name,
        FirebaseFieldNames.categoryIconCode: iconCode,
        FirebaseFieldNames.categoryColor: color,
        FirebaseFieldNames.enCategoryName: enCategoryName
      };
}
