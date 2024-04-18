// ignore_for_file: use_build_context_synchronously

import 'package:asan_yab/core/routes/routes.dart';
import 'package:asan_yab/core/utils/translation_util.dart';
import 'package:asan_yab/data/models/follow_user/follow_model.dart';
import 'package:asan_yab/data/repositoris/follow/follow_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../core/constants/firebase_collection_names.dart';
import '../../../data/models/users.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'sign_up.g.dart';

@riverpod
SignUpProvider signUp(SignUpRef ref) => SignUpProvider(ref);
@riverpod
CreateUserDetails createUser(CreateUserRef ref) => CreateUserDetails();

class SignUpProvider {
  final Ref ref;
  SignUpProvider(this.ref);

  Future signUp({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Center(
        child: LoadingAnimationWidget.fourRotatingDots(
            color: Colors.redAccent, size: 60),
      ),
    ).whenComplete(() => Navigator.pop(context));
    final text = texts(context);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      context.pushNamed(Routes.verifyEmail, pathParameters: {'email': email});
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(text.sign_up_method),
            duration: const Duration(seconds: 5),
          ),
        );
        context.pop();
      }
    }
  }
}

class CreateUserDetails {
  Future<void> addUserDetailsToFirebase({
    String? emailController,
    String? lastNameController,
    String? nameController,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final id = DateTime.now().millisecondsSinceEpoch;

    final userRef = FirebaseFirestore.instance
        .collection(FirebaseCollectionNames.user)
        .doc(uid);
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
    );
    final json = user.toJson();
    await userRef.set(json).whenComplete(() async {
      final userFollow = FollowModel(followers: [], following: []);
      await const FollowRepo().newUser(userRef.id, userFollow);
    });
  }

  Future<void> updateInviterRate(String inviterId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.user)
          .where('id', isEqualTo: int.parse(inviterId))
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot inviterDoc = querySnapshot.docs.first;
        final int currentRate = inviterDoc['invitationRate'] ?? 0;
        final int newRate = currentRate + 1;

        await FirebaseFirestore.instance
            .collection(FirebaseCollectionNames.user)
            .doc(inviterDoc.id)
            .update({'invitationRate': newRate});
      }
    } catch (e) {
      debugPrint('Error updating inviter rate: $e');
    }
  }
}