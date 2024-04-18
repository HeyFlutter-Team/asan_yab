import 'package:asan_yab/data/models/users.dart';
import 'package:asan_yab/data/repositoris/search_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'search_list_of_user.g.dart';

@riverpod
class SearchListOfUser extends _$SearchListOfUser {
  final singleRepo = const SearchRepo();
  @override
  List<Users> build() => [];
  void clearSearch() => state.clear();

  Future<List<Users>> getProfile(int? id) async {
    try {
      ref.read(loadingSearchUserProvider.notifier).state = true;
      state = await singleRepo.getSearchedUser(id);
      debugPrint(state.toString());
    } catch (e) {
      debugPrint(' in provider $e');
      rethrow;
    } finally {
      ref.read(loadingSearchUserProvider.notifier).state = false;
    }
    return state;
  }
}

final loadingSearchUserProvider = StateProvider<bool>((ref) => true);
final searchLoadingProvider = StateProvider<bool>((ref) => false);
