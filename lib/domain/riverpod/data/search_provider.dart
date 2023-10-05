import 'package:asan_yab/data/models/typesenses_models.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../servers/typesenseSearch.dart';

final searchTypeSenseProvider =
    StateNotifierProvider<MyPlaceList, List<SearchModel>>(
        (ref) => MyPlaceList([]));

class MyPlaceList extends StateNotifier<List<SearchModel>> {
  MyPlaceList(super.state);
  final searchController = TextEditingController();
  void clear() {
    state.clear();
  }

  Future<List<SearchModel>> search(String query) async {
    final search = SearchInstance();
    search.searchForData(query.toString().trim()).then((value) {
      state = value;
    });
    return state;
  }
}
