import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/firebase_collection_names.dart';
import '../../../data/models/favorite.dart';

final getFavoriteProvider = ChangeNotifierProvider<FirebaseFavoriteProvider>(
    (ref) => FirebaseFavoriteProvider());

class FirebaseFavoriteProvider extends ChangeNotifier {
  FirebaseFavoriteProvider();
  List<String> _favoriteList = [];
  List<String> get favoriteList => _favoriteList;
  final firestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance.currentUser;
  Future<void> getFavorite() async {
    _favoriteList = [];
    try {
      final data = await firestore
          .collection(FirebaseCollectionNames.favorite)
          .doc(firebaseAuth!.uid)
          .get();
      final data1 = Favorite.fromJson(data.data()!);
      _favoriteList.addAll(data1.items);
    } catch (e) {
      debugPrint(e.toString());
    }
    notifyListeners();
  }

  Future<void> setFavorite() async {
    try {
      if (firebaseAuth != null) {
        final documentReference = firestore
            .collection(FirebaseCollectionNames.favorite)
            .doc(firebaseAuth!.uid);

        final documentSnapshot = await documentReference.get();

        if (documentSnapshot.exists) {
          await documentReference
              .set({'items': favoriteList}, SetOptions(merge: true));
          debugPrint('List updated successfully');
        } else {
          await documentReference.set({'items': favoriteList});
          debugPrint('New document created with the list');
        }
      } else {
        debugPrint('User not logged in');
      }
    } catch (e) {
      debugPrint('Error updating list: $e');
    }
    notifyListeners();
  }

  void toggle(String id) {
    final isExist = favoriteList.contains(id);
    isExist ? _favoriteList.remove(id) : _favoriteList.add(id);
    debugPrint("$favoriteList");
    notifyListeners();
  }
}
