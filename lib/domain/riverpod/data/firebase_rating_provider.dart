import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseRatingProvider =
    ChangeNotifierProvider<FirebaseRating>((ref) => FirebaseRating());

class FirebaseRating extends ChangeNotifier {
  double _averageRatingProvider = 0;
  double get averageRatingProvider => _averageRatingProvider;
  set averageRatingProvider(double averageRatingProvider) {
    _averageRatingProvider = averageRatingProvider;
    notifyListeners();
  }

  Future<void> checkIfUserRated(
      BuildContext context, String postId, WidgetRef ref, double rate) async {
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
}
