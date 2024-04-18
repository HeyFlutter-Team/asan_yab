import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'search_place.g.dart';

@Riverpod(keepAlive: true)
class SearchPlace extends _$SearchPlace {
  @override
  String build() => '';
  String sendQuery(String search) {
    state = search;
    return state;
  }

  void clear() => state = '';
}
