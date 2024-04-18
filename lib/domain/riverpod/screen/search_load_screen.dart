import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'search_load_screen.g.dart';

@riverpod
class SearchLoading extends _$SearchLoading {
  @override
  bool build() => false;
}

@riverpod
class StateFollowPage extends _$StateFollowPage {
  @override
  int build() => 0;
}
