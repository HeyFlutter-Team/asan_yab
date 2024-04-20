import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'suggestion_page_provider.g.dart';

@riverpod
class Isloading extends _$Isloading {
  @override
  bool build() => false;

  bool loadingTrue() => state = true;
  bool loadingFalse() => state = false;
}

@riverpod
class SuggestionText extends _$SuggestionText {
  @override
  String build() => '';
  void updateSuggestion(String suggestion) => state = suggestion;
}
