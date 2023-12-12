

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/models/users.dart';
import '../../../main.dart';

class SignUpNotifier extends StateNotifier{
  SignUpNotifier(super.createFn);

  Future signUp(GlobalKey<FormState>signUpFormKey,BuildContext context,TextEditingController emailController,TextEditingController passwordController) async {
    final isValid = signUpFormKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
      if(e.code=='email-already-in-use'){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('این ایمیل قبلا استفاده شده است'),
        duration: Duration(seconds: 5),
      ));
    }
    }


  }

}

final signUpNotifierProvider=
    StateNotifierProvider((ref) => SignUpNotifier(ref));


class UserDetails extends StateNotifier{
  UserDetails(super.state);
final uid=FirebaseAuth.instance.currentUser!.uid;
  Future userDetails(TextEditingController emailController, TextEditingController lastNameController,TextEditingController  nameController,BuildContext context) async {
    final userId = getId();
    final userRef = FirebaseFirestore.instance.collection('User').doc(uid);

    final user = Users(
        createdAt: Timestamp.now(),
        email: emailController.text.trim(),
        lastName: lastNameController.text.trim(),
        name: nameController.text.trim());
    final json = user.toJson();
    userRef.set(json).whenComplete(
            () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('به آسان یاب خوش آمدید'),
          duration: Duration(seconds: 7),
        )));
  }

  String getId() {
    DateTime now = DateTime.now();
    String timeStamp = DateFormat('yyyyMMddHHmmss').format(now);

    return timeStamp;
  }
}

final userDetailsProvider=
    StateNotifierProvider((ref) => UserDetails(ref));