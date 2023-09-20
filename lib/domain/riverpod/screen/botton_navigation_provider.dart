import 'package:flutter_riverpod/flutter_riverpod.dart';

final buttonNavigationProvider =
    StateNotifierProvider<ButtonNavigation, int>((ref) => ButtonNavigation(0));

class ButtonNavigation extends StateNotifier<int> {
  ButtonNavigation(super._state);
  int selectedIndex(int index) => state = index;
}
