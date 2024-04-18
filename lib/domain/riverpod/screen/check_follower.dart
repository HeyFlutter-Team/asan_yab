import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/firebase_collection_names.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'check_follower.g.dart';

@riverpod
class CheckFollower extends _$CheckFollower {
  final _fireStore = FirebaseFirestore.instance;
  @override
  bool build() => true;
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
