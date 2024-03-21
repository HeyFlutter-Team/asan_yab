import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../presentation/pages/themeProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final firebaseRatingProvider =
    ChangeNotifierProvider<FirebaseRating>((ref) => FirebaseRating());

class FirebaseRating extends ChangeNotifier {
  double rate = 0;
  double _averageRatingProvider = 0;
  double get averageRatingProvider => _averageRatingProvider;
  set averageRatingProvider(double averageRatingProvider) {
    _averageRatingProvider = averageRatingProvider;
    notifyListeners();
  }

  Future<void> checkIfUserRated(
      BuildContext context, String postId, WidgetRef ref) async {
    final userUid = FirebaseAuth.instance.currentUser!.uid;
    if (userUid.isNotEmpty) {
      try {
        var result = await FirebaseFirestore.instance
            .collection('ratings')
            .where('placeId', isEqualTo: postId)
            .where('userId', isEqualTo: userUid)
            .get();

        if (result.docs.isNotEmpty) {
          // User has already rated the place
          print('User already rated this place');
          await updateRating(context, postId, ref, userUid, rate);
        } else {
          // Save the rating to the database
          await saveRating(context, postId, ref, userUid, rate);
        }
      } catch (e) {
        print('Error checking if user rated: $e');
        // Handle the error
      }
    }
    notifyListeners();
  }

  Future<void> saveRating(BuildContext context, String postId, WidgetRef ref,
      String userId, double rate) async {
    try {
      await FirebaseFirestore.instance.collection('ratings').add({
        'placeId': postId,
        'rating': rate,
        'userId': userId, // Include the user ID
      });

      Navigator.pop(context);
      // Close the rating screen after submission
    } catch (e) {
      print('Error saving rating: $e');
      // Handle the error
    }

    notifyListeners();
  }

  Future<void> updateRating(BuildContext context, String postId, WidgetRef ref,
      String userId, double rate) async {
    try {
      var existingRating = await FirebaseFirestore.instance
          .collection('ratings')
          .where('placeId', isEqualTo: postId)
          .where('userId', isEqualTo: userId)
          .get();

      if (existingRating.docs.isNotEmpty) {
        // Update the existing rating
        var docId = existingRating.docs.first.id;
        await FirebaseFirestore.instance
            .collection('ratings')
            .doc(docId)
            .update({
          'rating': rate,
        });

        Navigator.pop(context);
        // Close the rating screen after submission
      }
    } catch (e) {
      print('Error updating rating: $e');
      // Handle the error
    }
    notifyListeners();
  }

// Inside the FirebaseRating class
  Future<double> getAverageRatingForPlace(String postId) async {
    try {
      var result = await FirebaseFirestore.instance
          .collection('ratings')
          .where('placeId', isEqualTo: postId)
          .get();

      if (result.docs.isNotEmpty) {
        var ratings =
            result.docs.map((doc) => doc['rating'] as double).toList();
        var averageRating = ratings.reduce((a, b) => a + b) / ratings.length;

        return averageRating;
      } else {
        return 0;
      }
    } catch (e) {
      print('Error fetching average rating: $e');
      return 0;
    }
  }

  Future<void> getAverageRating({required String postId}) async {
    try {
      var result = await FirebaseFirestore.instance
          .collection('ratings')
          .where('placeId', isEqualTo: postId)
          .get();

      if (result.docs.isNotEmpty) {
        var ratings =
            result.docs.map((doc) => doc['rating'] as double).toList();
        var averageRating = ratings.reduce((a, b) => a + b) / ratings.length;

        _averageRatingProvider = averageRating;
      } else {
        _averageRatingProvider = 0;
      }
    } catch (e) {
      print('Error fetching average rating: $e');
      _averageRatingProvider = 0;
    }
    notifyListeners();
  }

  Widget stars(WidgetRef ref) {
    final averageRatingProvider = _averageRatingProvider;
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
        notifyListeners();
      },
    );
  }

  void showRating(
      BuildContext context, WidgetRef ref, User? user, String postId) async {
    update(postId, user).then((value) {
      showDialog(
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
                    ref.watch(firebaseRatingProvider).buildRating(),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: () async {
                        if (user != null) {
                          // Check if the user has already rated the place
                          final thisProvider = ref.read(firebaseRatingProvider);

                          await thisProvider.checkIfUserRated(
                              context, postId, ref);
                          rate = 0;

                          await thisProvider.getAverageRating(postId: postId);
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
          }).then((value) {
        rate = 0;
        notifyListeners();
      });
    });
  }

  Future<void> update(String postId, User? user) async {
    if (user == null) {
      return;
    }
    CollectionReference ratings =
        FirebaseFirestore.instance.collection('ratings');
    QuerySnapshot querySnapshot = await ratings
        .where('placeId', isEqualTo: postId)
        .where('userId', isEqualTo: user.uid)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> data =
          querySnapshot.docs.first.data() as Map<String, dynamic>;
      if (data.containsKey('rating')) {
        rate = data['rating'] as double;
      } else {
        rate = 0;
      }
    } else {
      rate = 0;
    }
    notifyListeners(); // Notify listeners about the changes
  }
}
