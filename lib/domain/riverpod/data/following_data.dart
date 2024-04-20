import 'package:asan_yab/data/models/follow_user/follow_model.dart';
import 'package:asan_yab/data/repositoris/single_user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositoris/follow/follow_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'following_data.g.dart';

final loadingFollowerProvider = StateProvider((ref) => false);

@riverpod
class FollowingData extends _$FollowingData {
  @override
  FollowModel build() => FollowModel();
  final followRepo = const FollowRepo();
  final getOtherUserData = SingleUserRepo();
  late FollowModel profile;
  Future<FollowModel> getProfile(String? uid) async {
    try {
      ref.read(loadingFollowingDataProvider.notifier).state = true;
      state = await followRepo.getCountUser(uid);
    } catch (e) {
      rethrow;
    } finally {
      for (final doc in state.following!) {
        if (doc != '') {
          final data = await getOtherUserData.fetchUser(doc);
          debugPrint(data.name);
          if (state.following!.contains(data.uid)) {
            ref.read(listOfDataProvider.notifier).state.add({
              'follow': false,
              "user": data,
            });
          } else {
            ref.read(listOfDataProvider.notifier).state.add({
              'follow': true,
              "user": data,
            });
          }
        }
      }
      for (final doc in state.followers!) {
        if (doc != '') {
          final data = await getOtherUserData.fetchUser(doc);
          debugPrint(data.name);
          if (state.following!.contains(data.uid)) {
            ref.read(listOfDataFollowersProvider.notifier).state.add({
              'followBack': false,
              "user": data,
            });
          } else {
            ref.read(listOfDataFollowersProvider.notifier).state.add({
              'followBack': true,
              "user": data,
            });
          }
        }
      }
      ref.read(loadingFollowingDataProvider.notifier).state = false;
    }

    return state;
  }

  Future<void> updateFollowers(
    String uid,
    String followId,
  ) async {
    try {
      ref.read(loadingFollowerProvider.notifier).state = true;
      await followRepo.updateFollowers(uid, followId);
    } catch (e) {
      rethrow;
    } finally {
      ref.read(loadingFollowerProvider.notifier).state = false;
    }
  }
}

final loadingFollowingDataProvider = StateProvider<bool>((ref) => false);
final listOfDataProvider =
    StateProvider<List<Map<String, dynamic>>>((ref) => []);
final listOfDataFollowersProvider =
    StateProvider<List<Map<String, dynamic>>>((ref) => []);
