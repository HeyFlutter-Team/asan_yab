import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final verifyEmailProvider =
    StateNotifierProvider<VerifyEmailNotifier, VerifyEmailState>((ref) {
  return VerifyEmailNotifier(ref);
});

class VerifyEmailState {
  final bool isEmailVerified;
  final bool canResendEmail;

  VerifyEmailState(this.isEmailVerified, this.canResendEmail);
}

class VerifyEmailNotifier extends StateNotifier<VerifyEmailState> {
  final Ref ref;
  late Timer _timer;

  VerifyEmailNotifier(this.ref) : super(VerifyEmailState(false, false)) {
    initialize();
  }

  Future<void> initialize() async {
    final isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      await sendVerificationEmail();
      _timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      state = VerifyEmailState(false, false);
      await Future.delayed(const Duration(seconds: 20));
      state = VerifyEmailState(false, true);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> checkEmailVerified() async {
    FirebaseAuth.instance.currentUser?.reload();
    if (FirebaseAuth.instance.currentUser != null) {
      final isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      if (isEmailVerified) {
        _timer.cancel();
        state = VerifyEmailState(isEmailVerified, state.canResendEmail);
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel timer
    super.dispose();
  }

  void cancelTimer() {
    _timer.cancel();
  }
}
