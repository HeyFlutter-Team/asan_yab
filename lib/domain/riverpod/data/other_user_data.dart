import 'package:asan_yab/data/models/users.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final otherUserProvider =
    StateNotifierProvider<OtherUser, Users?>((ref) => OtherUser(null));

class OtherUser extends StateNotifier<Users?> {
  OtherUser(super.state);
  void setDataUser(Users user){
    state = user;
    print('setUserCalled');
  }
}
