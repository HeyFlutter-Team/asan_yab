import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'email_verified_provider.dart';

class CheckEmailVerified extends StateNotifier {
  CheckEmailVerified(super.state);

  Future checkEmailVerified(
    WidgetRef ref,
    Timer timer,
  ) async {
    await FirebaseAuth.instance.currentUser!.reload();
    ref.read(isEmailVerified.notifier).state =
        FirebaseAuth.instance.currentUser!.emailVerified;
    if (ref.read(isEmailVerified.notifier).state) timer.cancel();
  }
}

final checkEmailVerifiedProvider =
    StateNotifierProvider((ref) => CheckEmailVerified(ref));
