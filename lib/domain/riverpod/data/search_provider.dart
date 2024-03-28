import 'package:asan_yab/data/models/search_model.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../servers/typesense_search.dart';

final searchTypeSenseProvider =
    StateNotifierProvider<SearchProvider, List<SearchModel>>(
        (ref) => SearchProvider([]));

class SearchProvider extends StateNotifier<List<SearchModel>> {
  SearchProvider(super.state);
  final searchController = TextEditingController();
  void clear() => state.clear();

  Future<List<SearchModel>> search(String query) async {
    final search = TypesenseSearch();
    search
        .searchForData(query.toString().trim())
        .then((value) => state = value);
    return state;
  }
}
