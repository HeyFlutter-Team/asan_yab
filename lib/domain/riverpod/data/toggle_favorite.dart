import 'package:flutter_riverpod/flutter_riverpod.dart';

final toggleProvider =
    StateNotifierProvider<ToggleFavorite, bool>((ref) => ToggleFavorite(false));

class ToggleFavorite extends StateNotifier<bool> {
  ToggleFavorite(super.state);

  bool toggle(bool toggle) => state = toggle;
}
