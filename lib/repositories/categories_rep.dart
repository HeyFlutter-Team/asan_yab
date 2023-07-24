import 'package:asan_yab/database/firebase_helper/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoriesRepository {
  final firebase = FirebaseFirestore.instance;
  final _path = 'Categories';

  Future<List<Category>> fetchCategories() async {
    try {
      final data = await firebase.collection(_path).get();

      debugPrint('Mahdi: fetchCategories: ${data.docs}');

      final categories = data.docs
                    .map((doc) => Category.fromJson(doc.data()))
                    .toList();
return categories;
    }catch (e){
      debugPrint('FetchCategories: Error: $e');
      return [];
    }
  }
}