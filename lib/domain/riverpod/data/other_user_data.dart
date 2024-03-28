import 'package:asan_yab/data/models/users.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final otherUserProvider =
    StateNotifierProvider<OtherUserDate, Users?>((ref) => OtherUserDate(null));

class OtherUserDate extends StateNotifier<Users?> {
  OtherUserDate(super.state);
  void setDataUser(Users user) => state = user;
}
