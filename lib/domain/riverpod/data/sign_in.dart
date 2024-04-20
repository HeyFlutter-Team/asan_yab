// ignore_for_file: use_build_context_synchronously, avoid_print
import 'package:asan_yab/domain/riverpod/data/profile_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../core/utils/translation_util.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'sign_in.g.dart';

@riverpod
SignInProvider signIn(SignInRef ref) => SignInProvider(ref);

class SignInProvider {
  final Ref read;

  SignInProvider(this.read);

  Future<void> signIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    final text = texts(context);
    try {
      read.read(profileDataProvider);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: LoadingAnimationWidget.fourRotatingDots(
                color: Colors.redAccent, size: 60),
          );
        },
      );
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(text.sign_in_method_1_if)),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(text.sign_in_method_2_if)),
        );
      } else if (e.code == 'too-many-requests') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(text.sign_in_method_3_if)),
        );
      }
    } catch (e) {
      debugPrint('younis general errors $e');
    } finally {
      Navigator.pop(context);
    }
  }

  Future<void> isMyEmailVerified(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      if (!user!.emailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حساب شما تایید نشده است و فیک میباشد')),
        );
      }
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }
}

@riverpod
class Loading extends _$Loading {
  @override
  bool build() => false;
  void setLoading(bool isLoading) => state = isLoading;
}

@riverpod
class Auth extends _$Auth {
  @override
  User? build() => FirebaseAuth.instance.currentUser;
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      state = null;
    } catch (e) {
      debugPrint('younis$e');
    }
  }
}

@riverpod
class RememberMe extends _$RememberMe {
  @override
  bool build() => false;
  void setRememberMe(bool value) => state = value;
}

@riverpod
class ObscureBool extends _$ObscureBool {
  @override
  bool build() => true;
  void isObscure() => state = !state;
}
