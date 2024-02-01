// ignore_for_file: use_build_context_synchronously

import 'package:asan_yab/data/models/follow_user/follow_model.dart';
import 'package:asan_yab/data/repositoris/follow/follow_repo.dart';
import 'package:asan_yab/presentation/pages/verify_email_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/users.dart';

class SignUpNotifier {
  final Ref ref;
  SignUpNotifier(this.ref);

  Future signUp(
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
    ).whenComplete(() => Navigator.pop(context));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VerifyEmailPage(
                    email: email,
                  )));
    } on FirebaseAuthException catch (e) {
      final languageText = AppLocalizations.of(context);
      print(e);
      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(languageText!.sign_up_method),
          duration: const Duration(seconds: 5),
        ));
        Navigator.pop(context);
      }
    }
  }
}

final signUpNotifierProvider = Provider((ref) => SignUpNotifier(ref));

class UserDetails {
  final id = DateTime.now().millisecondsSinceEpoch;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  Future<void> userDetails({
    String? emailController,
    String? lastNameController,
    String? nameController,
  }) async {
    final userRef = FirebaseFirestore.instance.collection('User').doc(uid);
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final user = Users(
        createdAt: Timestamp.now(),
        email: emailController!.trim(),
        lastName: lastNameController!.trim(),
        name: nameController!.trim(),
        uid: userRef.id,
        id: id,
        followerCount: 0,
        followingCount: 0,
        fcmToken: fcmToken!,
        isOnline: true);
    final json = user.toJson();
    await userRef.set(json).whenComplete(() async {
      final userFollow = FollowModel(followers: [], following: []);
      await FollowRepo().newUser(userRef.id, userFollow);
    });
  }
}

final userRegesterDetailsProvider = Provider((ref) => UserDetails());
