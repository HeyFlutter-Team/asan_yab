// ignore_for_file: use_build_context_synchronously

import 'package:asan_yab/presentation/pages/verify_email_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/users.dart';

class SignUpNotifier extends StateNotifier {
  final Ref ref;
  SignUpNotifier(super.createFn, this.ref);

  Future signUp({required BuildContext context,required String email,required String password}) async {


    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const Center(child:
      CircularProgressIndicator(
        color: Colors.red,

      ),),
    ).whenComplete(() => Navigator.pop(context));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email:email
              .trim(),
          password:password
              .trim());
      Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VerifyEmailPage(
                  email: email,
                )));
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(
          content:const Text('sign_up_method').tr(),
          duration:const Duration(seconds: 5),
        ));
        Navigator.pop(context);
      }
    }
  }
}

final signUpNotifierProvider =
    StateNotifierProvider((ref) => SignUpNotifier(ref, ref));

class UserDetails extends StateNotifier {
  UserDetails(super.state);

  final id=DateTime.now().millisecondsSinceEpoch;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  Future userDetails({
    required String emailController,
    required String lastNameController,
    required String nameController,
  }) async {
    final userRef = FirebaseFirestore.instance.collection('User').doc(uid);

    final user = Users(
        createdAt: Timestamp.now(),
        email: emailController.trim(),
        lastName: lastNameController.trim(),
        name: nameController.trim(),
         uid: userRef.id,
        id: id
    );
    final json = user.toJson();
    userRef.set(json);
  }
}

final userDetailsProvider = StateNotifierProvider((ref) => UserDetails(ref));
