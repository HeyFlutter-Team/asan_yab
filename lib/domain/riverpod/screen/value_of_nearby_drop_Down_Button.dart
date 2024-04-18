import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'value_of_nearby_drop_Down_Button.g.dart';

@Riverpod(keepAlive: true)
class ValueOfDropButton extends _$ValueOfDropButton {
  @override
  double build() => 0.8;
  List<double> distance = [0.8, 1, 2, 3, 4, 5];
  void choiceDistance(double value) => state = value;
}
