import 'package:flutter_riverpod/flutter_riverpod.dart';

final valueOfDropButtonProvider =
    StateNotifierProvider<DropButtonProvider, double>(
        (ref) => DropButtonProvider(0.8));

class DropButtonProvider extends StateNotifier<double> {
  DropButtonProvider(super.state);

  List<double> distance = [0.8, 1, 2, 3, 4, 5];

  void choiceDistance(double d) => state = d;
}
