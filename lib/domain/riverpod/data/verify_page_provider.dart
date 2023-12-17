


import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// class EmailVerifiedNotifier extends StateNotifier<bool> {
//   EmailVerifiedNotifier() : super(false);
//
//   void setIsVerified(bool value) {
//     state = value;
//   }
//
// }

final isEmailVerifieds = StateProvider<bool>((ref) {
  return false;
});

// class CanResendEmailNotifier extends StateNotifier<bool> {
//   CanResendEmailNotifier() : super(false);

//   void setCanResendEmail(bool value) {
//     state = value;
//   }
// }

final canResendEmailsProvider = StateProvider< bool>((ref) {
  return false;
});


class SendVirificationEmail extends StateNotifier{
  SendVirificationEmail(super.state);

  Future sendVerificationEmail(WidgetRef ref,BuildContext context)async{
    try{
      final user=FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      ref.read(canResendEmailsProvider.notifier).state=true;
      await Future.delayed(const Duration(seconds: 5));
      ref.read(canResendEmailsProvider.notifier).state=false;
    }catch(e){
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 5),
            content: Text('خطا در اتصال'),
          )
      );
    }
  }

}

final sendVirificationEmail=StateNotifierProvider((ref) => SendVirificationEmail(ref));


class CheckEmailVerified extends StateNotifier{
  CheckEmailVerified(super.state);

  Future checkEmailVerified(WidgetRef ref,Timer timer)async{
    await FirebaseAuth.instance.currentUser!.reload();
    ref.read(isEmailVerifieds.notifier).state =
          FirebaseAuth.instance.currentUser!.emailVerified;
    if(ref.read(isEmailVerifieds.notifier).state) timer.cancel();

  }
}

final checkEmailVerifiedProvider=StateNotifierProvider((ref) => CheckEmailVerified(ref));