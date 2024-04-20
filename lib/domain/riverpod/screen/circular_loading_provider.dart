import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'circular_loading_provider.g.dart';

@riverpod
class CircularLoading extends _$CircularLoading {
  @override
  bool build() => true;
  void toggleCircularLoading() => state = !state;
}
