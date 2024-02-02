import 'package:asan_yab/domain/riverpod/data/firebase_rating_provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../pages/themeProvider.dart';

class RatingWidgets extends ConsumerStatefulWidget {
  final String postId;
  const RatingWidgets({super.key, required this.postId});

  @override
  ConsumerState<RatingWidgets> createState() => _RatingWidgetsState();
}

class _RatingWidgetsState extends ConsumerState<RatingWidgets> {
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

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                showRating();
              },
              child: Text(
                "${firebaseRatingState.averageRatingProvider}",
                style: const TextStyle(fontSize: 26),
              ),
            ),
            GestureDetector(
              onTap: () {
                showRating();
              },
              child: stars(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRating() {
    return RatingBar.builder(
      initialRating: rate,
      itemSize: 35,
      minRating: 1,
      maxRating: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4),
      updateOnDrag: true,
      itemBuilder: (context, _) => const Icon(
        Icons.star_rate,
        color: Colors.amber,
      ),
      onRatingUpdate: (value) {
        rate = value;
      },
    );
  }

  void showRating() => showDialog(
      context: context,
      builder: (context) {
        final themeModel = ref.watch(themeModelProvider);
        final size = MediaQuery.of(context).size.width;
        final languageText = AppLocalizations.of(context);

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
                  languageText!.rating_widget_dialog,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 26),
                buildRating(),
                const SizedBox(height: 40),
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
                      Navigator.pop(context);
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
                        languageText.done_click,
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
  Widget stars() {
    final averageRatingProvider =
        ref.watch(firebaseRatingProvider).averageRatingProvider;

    return Row(
      children: [
        Icon(
          Icons.star,
          color: averageRatingProvider <= 0 ? Colors.grey : Colors.amber,
        ),
        Icon(
          Icons.star,
          color: averageRatingProvider <= 1 ? Colors.grey : Colors.amber,
        ),
        Icon(
          Icons.star,
          color: averageRatingProvider <= 2 ? Colors.grey : Colors.amber,
        ),
        Icon(
          Icons.star,
          color: averageRatingProvider <= 3 ? Colors.grey : Colors.amber,
        ),
        Icon(
          Icons.star,
          color: averageRatingProvider <= 4 ? Colors.grey : Colors.amber,
        ),
      ],
    );
  }
}
