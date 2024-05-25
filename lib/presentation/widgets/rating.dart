import 'package:asan_yab/core/utils/convert_digits_to_farsi.dart';
import 'package:asan_yab/data/models/language.dart';
import 'package:asan_yab/domain/riverpod/data/firebase_rating_provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositoris/language_repository.dart';

class RatingWidgets extends ConsumerStatefulWidget {
  final String postId;
  const RatingWidgets({super.key, required this.postId});

  @override
  ConsumerState<RatingWidgets> createState() => _RatingWidgetsState();
}

class _RatingWidgetsState extends ConsumerState<RatingWidgets> {
  User? user;

  @override
  void initState() {
    super.initState();

    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    final firebaseRatingState = ref.watch(firebaseRatingProvider);
    final isRTL = ref.watch(languageProvider).code == 'fa';

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                bool isLogin = FirebaseAuth.instance.currentUser != null;
                if (isLogin) {
                  ref
                      .watch(firebaseRatingProvider)
                      .showRating(context, ref, user, widget.postId);
                }
              },
              child: Text(
                isRTL
                    ? convertDigitsToFarsi(
                        "${firebaseRatingState.averageRatingProvider}"
                            .substring(0, 3))
                    : "${firebaseRatingState.averageRatingProvider}"
                        .substring(0, 3),
                style: const TextStyle(fontSize: 26),
              ),
            ),
            GestureDetector(
              onTap: () {
                bool isLogin = FirebaseAuth.instance.currentUser != null;
                if (isLogin) {
                  ref
                      .watch(firebaseRatingProvider)
                      .showRating(context, ref, user, widget.postId);
                }
              },
              child: ref.watch(firebaseRatingProvider).stars(ref),
            ),
          ],
        ),
      ),
    );
  }
}
