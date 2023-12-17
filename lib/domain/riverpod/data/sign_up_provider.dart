import 'package:asan_yab/main.dart';
import 'package:asan_yab/presentation/pages/verify_email_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/models/users.dart';
import 'controllers_provider.dart';

class SignUpNotifier extends StateNotifier {
  final Ref ref;
  SignUpNotifier(super.createFn, this.ref);

  Future signUp({required BuildContext context,required String email,required String password}) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Signing up...')),
    );
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('این ایمیل قبلا استفاده شده است'),
          duration: Duration(seconds: 5),
        ));
      }
    }
  }
}

final signUpNotifierProvider =
    StateNotifierProvider((ref) => SignUpNotifier(ref, ref));

class UserDetails extends StateNotifier {
  UserDetails(super.state);
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
        name: nameController.trim());
    final json = user.toJson();
    userRef.set(json);
  }
}

final userDetailsProvider = StateNotifierProvider((ref) => UserDetails(ref));
