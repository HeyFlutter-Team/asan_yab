import 'package:asan_yab/presentation/pages/http_get_post_search.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/place.dart';

part 'search_user_provider.g.dart';

@riverpod
Future<List<Place>> searchUser(SearchUserRef ref) async {
  return ref.watch(userProvider).getUser();
}
