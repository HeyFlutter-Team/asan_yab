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
import '../../../presentation/pages/sign_up_page.dart';

class SignUpNotifier {
  final Ref ref;
  SignUpNotifier(this.ref);

  Future signUp(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VerifyEmailPage(
                    email: email,
                    password: password,
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
    }finally{
      ref.read(isSignUppingProvider.notifier).state=false;

    }
  }
}

final signUpNotifierProvider = Provider((ref) => SignUpNotifier(ref));

class CreateUserDetails {
  Future<void> addUserDetailsToFirebase(
      {String? emailController,
      String? lastNameController,
      String? nameController,
      String? passwordController}) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final id = DateTime.now().millisecondsSinceEpoch;

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
        isOnline: true,
        password: passwordController);
    final json = user.toJson();
    await userRef.set(json).whenComplete(() async {
      final userFollow = FollowModel(followers: [], following: []);
      await FollowRepo().newUser(userRef.id, userFollow);
    });
  }

  Future<void> updateInviterRate(String inviterId) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('User')
          .where('id', isEqualTo: int.parse(inviterId))
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot inviterDoc = querySnapshot.docs.first;
        final int currentRate = inviterDoc['invitationRate'] ?? 0;
        final int newRate = currentRate + 1;

        await FirebaseFirestore.instance
            .collection('User')
            .doc(inviterDoc.id)
            .update({'invitationRate': newRate});
      }
    } catch (e) {
      print('Error updating inviter rate: $e');
    }
  }
}

final userRegesterDetailsProvider = Provider((ref) => CreateUserDetails());
