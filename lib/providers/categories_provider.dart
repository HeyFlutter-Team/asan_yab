import 'package:asan_yab/database/firebase_helper/category.dart';
import 'package:asan_yab/repositories/categories_rep.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../database/firebase_helper/place.dart';

class CategoriesProvider with ChangeNotifier {
  final categoriesRepository = CategoriesRepository();

  List<Category> _categories = [];
  List<Category> get categories => _categories;
  set categories(List<Category> categories) {
    _categories = categories;
    notifyListeners();
  }

  Future<List<Category>> getCategories() async {
    final newCategories = await categoriesRepository.fetchCategories();
    _categories = newCategories;
    notifyListeners();
    return _categories;
  }

  Future<Place?> fetchSinglePlace(String id) async {
    final database = FirebaseFirestore.instance;
    try {
      final querySnapshot = await database.collection('Places').doc(id).get();
      final place = Place.fromJson(querySnapshot.data()!);
      return place;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
