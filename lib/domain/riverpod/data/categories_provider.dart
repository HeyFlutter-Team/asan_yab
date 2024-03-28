import 'package:asan_yab/data/models/category.dart';
import 'package:asan_yab/data/repositoris/categories_repo.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoriesProvider =
    StateNotifierProvider<CategoriesProvider, List<Category>>(
        (ref) => CategoriesProvider([]));

class CategoriesProvider extends StateNotifier<List<Category>> {
  final categoriesRepository = CategoriesRepo();

  CategoriesProvider(super.state);

  Future<List<Category>> getCategories() async {
    final newCategories = await categoriesRepository.fetchCategories();
    state = newCategories;

    return state;
  }
}
