import 'package:asan_yab/data/models/users.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'other_user_data.g.dart';

@riverpod
class OtherUserData extends _$OtherUserData {
  @override
  Users? build() => null;
  void setDataUser(Users user) => state = user;
}
