import 'package:asan_yab/data/models/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoriesRepository {
  CategoriesRepository();
  final firestore = FirebaseFirestore.instance;
  final _path = 'Categories';

  Future<List<Category>> fetchCategories() async {
    try {
      final data = await firestore.collection(_path).get();
      final categories =
          data.docs.map((doc) => Category.fromJson(doc.data())).toList();
      return categories;
    } catch (e) {
      debugPrint('FetchCategories: Error: $e');
      return [];
    }
  }
}
