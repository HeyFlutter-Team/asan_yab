import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailVerifiedNotifier extends StateNotifier<bool> {
  EmailVerifiedNotifier() : super(false);

  void setIsVerified(bool value) => state = value;
}

final isEmailVerified = StateProvider<bool>((ref) => false);

class CanResendEmailNotifier extends StateNotifier<bool> {
  CanResendEmailNotifier() : super(false);

  void setCanResendEmail(bool value) => state = value;
}

final canResendEmailsProvider = StateProvider<bool>((ref) => false);

class SendVerificationEmail extends StateNotifier {
  SendVerificationEmail(super.state);

  Future sendVerificationEmail(
    WidgetRef ref,
    BuildContext context,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      ref.read(canResendEmailsProvider.notifier).state = true;
      await Future.delayed(const Duration(seconds: 5));
      ref.read(canResendEmailsProvider.notifier).state = false;
    } catch (e) {
      debugPrint(e.toString());
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 5),
            content: Text('خطا در اتصال'),
          ),
        );
      }
    }
  }
}

final sendVerificationEmail =
    StateNotifierProvider((ref) => SendVerificationEmail(ref));

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
