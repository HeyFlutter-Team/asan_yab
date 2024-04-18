import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'toggle_favorite.g.dart';

@riverpod
class ToggleFavorite extends _$ToggleFavorite {
  @override
  bool build() => false;
  bool toggle(bool toggle) => state = toggle;
}
