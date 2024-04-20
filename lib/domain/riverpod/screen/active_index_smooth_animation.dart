import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'active_index_smooth_animation.g.dart';

@riverpod
class ActiveIndexSmoothAnimation extends _$ActiveIndexSmoothAnimation {
  @override
  int build() => 0;
  int activeIndex(int index) => state = index;
}
