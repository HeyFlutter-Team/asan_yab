import 'package:asan_yab/database/firebase_helper/category.dart';
import 'package:asan_yab/repositories/categories_rep.dart';
import 'package:flutter/material.dart';

class CategoriesProvider with ChangeNotifier {
  final categoriesRepository = CategoriesRepository();

  List<Category> _categories = [];
  List<Category> get categories => _categories;
  set categories(List<Category> categories){
    _categories = categories;
    notifyListeners();
  }
  Future<List<Category>> getCategories () async {
    final newCategories = await categoriesRepository.fetchCategories();
    _categories = newCategories;
    notifyListeners();
    return _categories;
    
  }
 
}