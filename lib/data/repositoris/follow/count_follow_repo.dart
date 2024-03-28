import 'package:asan_yab/data/models/follow_user/follow_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/firebase_collection_names.dart';

class CountFollowRepo {
  const CountFollowRepo();
  Future<FollowModel> getCountUser(String? uid) async {
    final fireStore = FirebaseFirestore.instance;
    try {
      final query = await fireStore
          .collection(FirebaseCollectionNames.user)
          .doc(uid)
          .collection(FirebaseCollectionNames.follow)
          .doc(uid)
          .get();
      final followUserProfile = FollowModel.fromJson(query.data()!);
      return followUserProfile;
    } catch (e) {
      debugPrint('in count follow ${e.toString()}');
      rethrow;
    }
  }
}
