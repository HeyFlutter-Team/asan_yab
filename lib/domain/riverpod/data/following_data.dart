import 'package:asan_yab/data/models/follow_user/follow_model.dart';
import 'package:asan_yab/data/repositoris/follow/count_follow.dart';
import 'package:asan_yab/data/repositoris/single_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final followingDataProvider = StateNotifierProvider<FollowingData, FollowModel>(
    (ref) => FollowingData(FollowModel(), ref));

class FollowingData extends StateNotifier<FollowModel> {
  FollowingData(super.state, this.ref);
  final Ref ref;
  final singleRepo = CountFollowRepo();
  final getOtherUserData = SingleUserRepo();
  late FollowModel profile;
  Future<FollowModel> getProfile(String? uid) async {
    try {
      ref.read(loadingFollowingDataProvider.notifier).state = true;
      state = await singleRepo.getCountUser(uid);
    } catch (e) {
      rethrow;
    } finally {
      for (final doc in state.following!) {
        if (doc != '') {
          final data = await getOtherUserData.getFetchUser(doc);
          print('${data.name}');
          if (state.following!.contains(data.uid)) {
            ref
                .read(listOfDataProvider.notifier)
                .state
                .add({'follow': false, "user": data});
          } else {
            ref
                .read(listOfDataProvider.notifier)
                .state
                .add({'follow': true, "user": data});
          }
        }
      }
      for (final doc in state.followers!) {
        if (doc != '') {
          final data = await getOtherUserData.getFetchUser(doc);
          print('${data.name}');
          if (state.following!.contains(data.uid)) {
            ref
                .read(listOfDataFollowersProvider.notifier)
                .state
                .add({'followBack': false, "user": data});
          } else {
            ref
                .read(listOfDataFollowersProvider.notifier)
                .state
                .add({'followBack': true, "user": data});
          }
        }
      }
      ref.read(loadingFollowingDataProvider.notifier).state = false;
    }

    return state;
  }
}

final loadingFollowingDataProvider = StateProvider<bool>((ref) => false);
final listOfDataProvider =
    StateProvider<List<Map<String, dynamic>>>((ref) => []);
final listOfDataFollowersProvider =
    StateProvider<List<Map<String, dynamic>>>((ref) => []);
