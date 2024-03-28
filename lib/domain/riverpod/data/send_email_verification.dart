import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SendEmailVerification extends StateNotifier {
  SendEmailVerification(super.state);

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
    StateNotifierProvider((ref) => SendEmailVerification(ref));

final canResendEmailsProvider = StateProvider<bool>((ref) => false);

class CanResendEmailNotifier extends StateNotifier<bool> {
  CanResendEmailNotifier() : super(false);

  void setCanResendEmail(bool value) => state = value;
}
