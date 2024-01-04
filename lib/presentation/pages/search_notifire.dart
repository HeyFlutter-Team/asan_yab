import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchNotifierProvider = StateNotifierProvider<SearchNotifier, String>(
        (ref) => SearchNotifier(''));

class SearchNotifier extends StateNotifier<String> {
  SearchNotifier(super.state);
  String sendQuery(String search) {
    state = search;
    return state;
  }

  void clear() {
    state = '';
  }
}
