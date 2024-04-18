import 'package:asan_yab/data/models/category.dart';
import 'package:asan_yab/data/repositoris/categories_repo.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'categories.g.dart';

@riverpod
class Categories extends _$Categories {
  final categoriesRepository = CategoriesRepo();
  @override
  List<Category> build() => [];
  Future<List<Category>> getCategories() async {
    final newCategories = await categoriesRepository.fetchCategories();
    state = newCategories;
    return state;
  }
}
