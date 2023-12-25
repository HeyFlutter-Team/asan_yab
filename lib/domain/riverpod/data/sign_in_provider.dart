// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:asan_yab/presentation/pages/main_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Sign In method
final signInProvider = StateNotifierProvider((ref) => SignIn(ref, ref));

class SignIn extends StateNotifier {
  final Ref ref;
  SignIn(super.state, this.ref);

  Future signIn(
      {required BuildContext context,
      required String email,
      required String password}) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Colors.red,
        ),
      ),
    );

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.trim(), password: password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    } on FirebaseAuthException catch (e) {
      print('Younis$e');
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content:const Text('sign_in_method_1_if').tr()));
        Navigator.pop(context);
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar( SnackBar(content:const Text('sign_in_method_2_if').tr()));
        Navigator.pop(context);

      } else if (e.code == 'too-many-requests') {
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(
            content:const Text(
                'sign_in_method_3_if').tr()));
        Navigator.pop(context);

      }
    } catch (e) {
      print('younis general errors $e');
    }
  }
}

//Cheak box method
class IsCheckNotifier extends StateNotifier<bool> {
  IsCheckNotifier() : super(false);

   setIsCheck(bool value) {
    state = value;
  }
}

final isCheckProvider = StateNotifierProvider<IsCheckNotifier, bool>((ref) {
  return IsCheckNotifier();
});

class ObscureBool extends StateNotifier<bool> {
  ObscureBool() : super(true);

  void isObscure() {
    state = !state;
    print('younis obscure = $state');
  }
}

final isObscureProvider =
    StateNotifierProvider<ObscureBool, bool>((ref) => ObscureBool());
