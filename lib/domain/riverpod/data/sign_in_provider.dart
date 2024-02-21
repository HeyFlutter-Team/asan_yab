// ignore_for_file: use_build_context_synchronously, avoid_print
import 'package:asan_yab/domain/riverpod/data/profile_data_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//Sign In method
final signInProvider = Provider((ref) => SignInNotifier(ref));

class SignInNotifier {
  final Ref read;

  SignInNotifier(this.read);

  Future<void> signIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      read.read(userDetailsProvider);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator(
            color: Colors.red,
          )); // Use the custom dialog widget
        },
      );
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      final languageText = AppLocalizations.of(context);
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(languageText!.sign_in_method_1_if)),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(languageText!.sign_in_method_2_if)),
        );
      } else if (e.code == 'too-many-requests') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(languageText!.sign_in_method_3_if)),
        );
      }
    } catch (e) {
      print('younis general errors $e');
    }finally{
      Navigator.pop(context);
    }
  }
  Future<void> isMyEmailVerified(BuildContext context)async {
    final user=FirebaseAuth.instance.currentUser;
    try{
      if(!user!.emailVerified){
          ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('حساب شما تایید نشده است و فیک میباشد')),
         );
      }

    }on FirebaseAuthException catch (e){
      print(e);
    }
  }
}


class LoadingNotifier extends StateNotifier<bool> {
  LoadingNotifier() : super(false);

  void setLoading(bool isLoading) {
    state = isLoading;
  }
}

final loadingProvider = StateNotifierProvider<LoadingNotifier, bool>((ref) {
  return LoadingNotifier();
});


class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier() : super(FirebaseAuth.instance.currentUser);

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      state = null; // Clear the current user upon successful sign-out
    } catch (e) {
      // Handle sign-out failure, if needed
      print('younis$e');
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});


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
  }
}

final isObscureProvider =
    StateNotifierProvider<ObscureBool, bool>((ref) => ObscureBool());
