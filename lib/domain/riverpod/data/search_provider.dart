import 'package:asan_yab/data/models/typesenses_models.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../servers/typesenseSearch.dart';

final searchTypeSenseProvider =
    StateNotifierProvider<MyPlaceList, List<SearchModel>>(
        (ref) => MyPlaceList([]));

class MyPlaceList extends StateNotifier<List<SearchModel>> {
  MyPlaceList(super.state);

  Future<List<SearchModel>> search(String query) async {
    final search = SearchInstance();
    search.searchForData(query).then((value) {
      state = value;
    });
    return state;
  }
}
