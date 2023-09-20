import 'package:flutter_riverpod/flutter_riverpod.dart';

final valueOfDropButtonProvider =
    StateNotifierProvider<ValueOfDropButtonProvider, double>(
        (ref) => ValueOfDropButtonProvider(0.8));

class ValueOfDropButtonProvider extends StateNotifier<double> {
  ValueOfDropButtonProvider(super.state);

  List<double> distance = [0.8, 1, 2, 3, 4, 5];

  void choiceDistacne(double d) => state = d;
}
