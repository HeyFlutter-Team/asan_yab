import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/favorite.dart';

final getInformationProvider =
    ChangeNotifierProvider<Information>((ref) => Information());

class Information extends ChangeNotifier {
  // List<Post> posts = [];
  List<String> favoriteList = [];
  Future<void> getFavorite() async {
    favoriteList = [];
    final user = 'ali';
    final data =
        await FirebaseFirestore.instance.collection('Favorite').doc(user).get();
    final data1 = Favorite.fromJson(data.data()!);
    notifyListeners();
    favoriteList.addAll(data1.items);
  }

  // Future<void> getPosttt() async {
  //   posts = [];
  //   for (int index = 0; index < favoriteList.length; index++) {
  //     final data = await FirebaseFirestore.instance
  //         .collection('data')
  //         .doc(favoriteList[index])
  //         .get();
  //     final data1 = Post.fromJson(data.data()!);
  //
  //     posts.add(data1);
  //   }
  //   notifyListeners();
  // }

  Future<void> setFavorite() async {
    final user = 'ali';
    try {
      if (user != null) {
        // Reference to the 'Favorite' collection and the document with the user's email
        final documentReference =
            FirebaseFirestore.instance.collection('Favorite').doc(user);

        final documentSnapshot = await documentReference.get();

        if (documentSnapshot.exists) {
          // Update the document with the new list
          await documentReference
              .set({'items': favoriteList}, SetOptions(merge: true));
          debugPrint('List updated successfully');
        } else {
          // If the document doesn't exist, create a new one with the list
          await documentReference.set({'items': favoriteList});
          debugPrint('New document created with the list');
        }
      } else {
        debugPrint('User not logged in');
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating list: $e');
    }
  }

  void toggle(String id) {
    final isExist = favoriteList.contains(id);
    if (isExist) {
      favoriteList.remove(id);
    } else {
      favoriteList.add(id);
    }
    debugPrint("$favoriteList");
    notifyListeners();
  }
}
