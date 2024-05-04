import 'package:asan_yab/data/repositoris/follow/follow_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final followHttpsProvider =
    StateNotifierProvider((ref) => FollowHttps(ref, ref));

class FollowHttps extends StateNotifier {
  final Ref ref;
  FollowHttps(super.state, this.ref);
  final followerRepo = FollowRepo();

  Future<void> updateFollowers(String uid, String followId) async {
    try {
      ref.read(loadingFollowerProvider.notifier).state = true;
      await followerRepo.updateFollowers(uid, followId);
    } catch (e) {
      rethrow;
    } finally {
      ref.read(loadingFollowerProvider.notifier).state = false;
    }
  }
}

final loadingFollowerProvider = StateProvider((ref) => false);
final loadingFollowOrUnfollowProvider = StateProviderFamily<bool, int>((ref, index) => false);
