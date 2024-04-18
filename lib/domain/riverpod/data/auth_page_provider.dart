import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_page_provider.g.dart';

@riverpod
class AuthState extends _$AuthState {
  @override
  bool build() => true;
  void toggleLoginState() => state = !state;
}
