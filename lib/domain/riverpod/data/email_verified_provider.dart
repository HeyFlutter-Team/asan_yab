import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailVerifiedProvider extends StateNotifier<bool> {
  EmailVerifiedProvider() : super(false);

  void setIsVerified(bool value) => state = value;
}

final isEmailVerified = StateProvider<bool>((ref) => false);
