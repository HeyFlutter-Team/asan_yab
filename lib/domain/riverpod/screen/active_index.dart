import 'package:flutter_riverpod/flutter_riverpod.dart';

final activeIndexNotifier = StateNotifierProvider<ActiveIndexNotifier, int>(
    (ref) => ActiveIndexNotifier(0));

class ActiveIndexNotifier extends StateNotifier<int> {
  ActiveIndexNotifier(super._state);

  void activeIndex(int index) => state = index;
}
