import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final followerProvider = StateNotifierProvider<FollowCheckerProvider, bool>(
    (ref) => FollowCheckerProvider(true, ref));

class FollowCheckerProvider extends StateNotifier<bool> {
  final Ref ref;
  FollowCheckerProvider(super.state, this.ref);
  final _fireStore = FirebaseFirestore.instance;

  Future<bool> followOrUnFollow(String uid, String followId) async {
    try {
      ref.read(loadingFollowers.notifier).state = true;
      final snap = await _fireStore
          .collection('User')
          .doc(uid)
          .collection('Follow')
          .doc(uid)
          .get();
      final following = (snap.data()! as dynamic)['following'];
      if (following.contains(followId)) {
        state = false;
      } else {
        state = true;
      }
    } catch (e) {
      print(e.toString());
    } finally {
      ref.read(loadingFollowers.notifier).state = false;
    }

    return state;
  }
}

final loadingFollowers = StateProvider((ref) => false);