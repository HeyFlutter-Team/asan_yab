import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/firebase_collection_names.dart';

final followerProvider = StateNotifierProvider<FollowCheckerProvider, bool>(
    (ref) => FollowCheckerProvider(true, ref));

class FollowCheckerProvider extends StateNotifier<bool> {
  final Ref ref;
  FollowCheckerProvider(super.state, this.ref);
  final _fireStore = FirebaseFirestore.instance;

  Future<bool> followOrUnFollow(
    String uid,
    String followId,
  ) async {
    try {
      final snap = await _fireStore
          .collection(FirebaseCollectionNames.user)
          .doc(uid)
          .collection(FirebaseCollectionNames.follow)
          .doc(uid)
          .get();
      final following = (snap.data()! as dynamic)['following'];
      following.contains(followId) ? state = false : state = true;
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      ref.read(loadingFollowers.notifier).state = false;
    }

    return state;
  }
}

final loadingFollowers = StateProvider((ref) => false);
