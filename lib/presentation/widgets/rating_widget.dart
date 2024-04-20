// ignore_for_file: must_be_immutable

import 'package:asan_yab/core/utils/convert_digits_to_farsi.dart';
import 'package:asan_yab/core/extensions/language.dart';
import 'package:asan_yab/core/utils/translation_util.dart';
import 'package:asan_yab/domain/riverpod/data/firebase_rating_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../data/repositoris/language_repo.dart';
import '../../data/repositoris/theme_Provider.dart';
import 'create_rating_widget.dart';
import 'stars_widget.dart';

class RatingWidget extends ConsumerStatefulWidget {
  final String postId;
  const RatingWidget({super.key, required this.postId});

  @override
  ConsumerState<RatingWidget> createState() => _RatingWidgetsState();
}

class _RatingWidgetsState extends ConsumerState<RatingWidget> {
  User? user;
  double rate = 0;

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
                if (isLogin) showRating();
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
                if (isLogin) showRating();
              },
              child: const StarsWidget(),
            ),
          ],
        ),
      ),
    );
  }

  void showRating() => showDialog(
      context: context,
      builder: (context) {
        final themeModel = ref.watch(themeModelProvider);
        final size = MediaQuery.of(context).size.width;
        final text = texts(context);

        return Center(
          child: Container(
            width: size - 50,
            height: size / 1.6,
            decoration: BoxDecoration(
                color: (themeModel.currentThemeMode == ThemeMode.dark)
                    ? Colors.grey[700]
                    : Colors.white,
                borderRadius: BorderRadius.circular(50)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  text.rating_widget_dialog,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 26.h),
                CreateRatingWidget(rate: rate),
                SizedBox(height: 40.h),
                GestureDetector(
                  onTap: () async {
                    if (user != null) {
                      // Check if the user has already rated the place
                      final thisProvider = ref.read(firebaseRatingProvider);

                      await thisProvider.checkIfUserRated(
                          context, widget.postId, ref, rate);

                      await thisProvider.getAverageRating(
                          postId: widget.postId);
                      rate = 0;
                    } else {
                      // Handle unauthenticated user
                      debugPrint('User not authenticated');
                      context.pop();
                    }
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(50),
                            bottomLeft: Radius.circular(50)),
                        color: Colors.amber),
                    width: double.infinity,
                    height: 60,
                    child: Center(
                      child: Text(
                        text.done_click,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      });
}
