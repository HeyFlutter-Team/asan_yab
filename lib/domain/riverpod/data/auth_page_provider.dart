import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthPageProvider extends StateNotifier<bool> {
  AuthPageProvider() : super(true);

  void toggleLoginState() => state = !state;
}

final authPageStateProvider =
    StateNotifierProvider<AuthPageProvider, bool>((ref) => AuthPageProvider());
