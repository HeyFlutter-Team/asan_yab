import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'botton_navigation_provider.g.dart';

@riverpod
class StateButtonNavigationBar extends _$StateButtonNavigationBar {
  @override
  int build() => 0;
  int selectedIndex(int index) => state = index;
}
