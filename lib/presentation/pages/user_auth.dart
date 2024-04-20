import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'main_page.dart';
import 'verify_email_page.dart';

class UserAuth extends StatelessWidget {
  const UserAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasError) {
          return buildErrorWidget();
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return buildLoadingWidget();
        } else if (snapshot.hasData && snapshot.data != null) {
          final user = snapshot.data!;
          return user.emailVerified
              ? const MainPage()
              : VerifyEmailPage(email: user.email ?? '');
        } else {
          return const MainPage();
        }
      },
    );
  }

  Widget buildErrorWidget() => const Center(
        child: Text(
          'Error connecting to server',
          style: TextStyle(color: Colors.red),
        ),
      );

  Widget buildLoadingWidget() => Center(
        child: LoadingAnimationWidget.fourRotatingDots(
            color: Colors.redAccent, size: 60),
      );
}
