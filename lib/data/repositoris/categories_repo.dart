import 'package:asan_yab/data/models/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../core/constants/firebase_collection_names.dart';

class CategoriesRepo {
  CategoriesRepo();
  final firestore = FirebaseFirestore.instance;
  Future<List<Category>> fetchCategories() async {
    try {
      final data =
          await firestore.collection(FirebaseCollectionNames.categories).get();
      final categories =
          data.docs.map((doc) => Category.fromJson(doc.data())).toList();
      return categories;
    } catch (e) {
      debugPrint('FetchCategories: Error: $e');
      return [];
    }
  }
}
