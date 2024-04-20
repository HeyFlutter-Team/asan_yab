import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/firebase_collection_names.dart';

final firebaseRatingProvider = ChangeNotifierProvider<FirebaseRatingProvider>(
    (ref) => FirebaseRatingProvider());

class FirebaseRatingProvider extends ChangeNotifier {
  FirebaseRatingProvider();
  final firestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance.currentUser;
  double _averageRatingProvider = 0;
  double get averageRatingProvider => _averageRatingProvider;
  set averageRatingProvider(double averageRatingProvider) {
    _averageRatingProvider = averageRatingProvider;
    notifyListeners();
  }

  Future<void> checkIfUserRated(
    BuildContext context,
    String postId,
    WidgetRef ref,
    double rate,
  ) async {
    if (firebaseAuth!.uid.isNotEmpty) {
      try {
        final result = await firestore
            .collection(FirebaseCollectionNames.ratings)
            .where('placeId', isEqualTo: postId)
            .where('userId', isEqualTo: firebaseAuth!.uid)
            .get();

        if (result.docs.isNotEmpty && context.mounted) {
          debugPrint('User already rated this place');

          await updateRating(context, postId, ref, firebaseAuth!.uid, rate);
        } else {
          if (context.mounted) {
            await saveRating(context, postId, ref, firebaseAuth!.uid, rate);
          }
        }
      } catch (e) {
        debugPrint('Error checking if user rated: $e');
      }
    }
    notifyListeners();
  }

  Future<void> saveRating(
    BuildContext context,
    String postId,
    WidgetRef ref,
    String userId,
    double rate,
  ) async {
    try {
      await firestore.collection(FirebaseCollectionNames.ratings).add({
        'placeId': postId,
        'rating': rate,
        'userId': userId,
      });
      if (context.mounted) {
        context.pop();
      }
    } catch (e) {
      debugPrint('Error saving rating: $e');
    }
    notifyListeners();
  }

  Future<void> updateRating(
    BuildContext context,
    String postId,
    WidgetRef ref,
    String userId,
    double rate,
  ) async {
    try {
      final existingRating = await firestore
          .collection(FirebaseCollectionNames.ratings)
          .where('placeId', isEqualTo: postId)
          .where('userId', isEqualTo: userId)
          .get();

      if (existingRating.docs.isNotEmpty) {
        final docId = existingRating.docs.first.id;
        await firestore
            .collection(FirebaseCollectionNames.ratings)
            .doc(docId)
            .update({'rating': rate});
        if (context.mounted) {
          context.pop();
        }
      }
    } catch (e) {
      debugPrint('Error updating rating: $e');
    }
    notifyListeners();
  }

  Future<double> getAverageRatingForPlace(String postId) async {
    try {
      final result = await firestore
          .collection(FirebaseCollectionNames.ratings)
          .where('placeId', isEqualTo: postId)
          .get();

      if (result.docs.isNotEmpty) {
        final ratings =
            result.docs.map((doc) => doc['rating'] as double).toList();
        final averageRating = ratings.reduce((a, b) => a + b) / ratings.length;

        return averageRating;
      } else {
        return 0;
      }
    } catch (e) {
      debugPrint('Error fetching average rating: $e');
      return 0;
    }
  }

  Future<void> getAverageRating({required String postId}) async {
    try {
      final result = await firestore
          .collection(FirebaseCollectionNames.ratings)
          .where('placeId', isEqualTo: postId)
          .get();

      if (result.docs.isNotEmpty) {
        final ratings =
            result.docs.map((doc) => doc['rating'] as double).toList();
        final averageRating = ratings.reduce((a, b) => a + b) / ratings.length;

        _averageRatingProvider = averageRating;
      } else {
        _averageRatingProvider = 0;
      }
    } catch (e) {
      debugPrint('Error fetching average rating: $e');
      _averageRatingProvider = 0;
    }
    notifyListeners();
  }
}
