// ignore_for_file: use_build_context_synchronously, avoid_print
import 'package:asan_yab/domain/riverpod/data/profile_data_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/translation_util.dart';

//Sign In method
final signInProvider = Provider((ref) => SignInProvider(ref));

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
      read.read(profileDetailsProvider);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.red),
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

class LoadingNotifier extends StateNotifier<bool> {
  LoadingNotifier() : super(false);

  void setLoading(bool isLoading) => state = isLoading;
}

final loadingProvider =
    StateNotifierProvider<LoadingNotifier, bool>((ref) => LoadingNotifier());

class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier() : super(FirebaseAuth.instance.currentUser);

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      state = null;
    } catch (e) {
      debugPrint('younis$e');
    }
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, User?>((ref) => AuthNotifier());

class IsCheckNotifier extends StateNotifier<bool> {
  IsCheckNotifier() : super(false);

  setIsCheck(bool value) => state = value;
}

final isCheckProvider =
    StateNotifierProvider<IsCheckNotifier, bool>((ref) => IsCheckNotifier());

class ObscureBool extends StateNotifier<bool> {
  ObscureBool() : super(true);

  void isObscure() => state = !state;
}

final isObscureProvider =
    StateNotifierProvider<ObscureBool, bool>((ref) => ObscureBool());
