import 'package:flutter_riverpod/flutter_riverpod.dart';

final buttonNavigationProvider =
    StateNotifierProvider<ButtonNavigationProvider, int>(
        (ref) => ButtonNavigationProvider(0));

class ButtonNavigationProvider extends StateNotifier<int> {
  ButtonNavigationProvider(super._state);
  int selectedIndex(int index) => state = index;
}
