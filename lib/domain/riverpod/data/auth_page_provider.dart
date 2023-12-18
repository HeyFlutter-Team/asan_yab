import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthPageState extends StateNotifier<bool> {
  AuthPageState() : super(true);

  void toggleLoginState() {
    state = !state;
  }
}
final authPageStateProvider = StateNotifierProvider<AuthPageState, bool>((ref) {
  return AuthPageState();
});
//its