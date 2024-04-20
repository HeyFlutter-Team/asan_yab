import 'package:asan_yab/data/models/users.dart';
import 'package:asan_yab/data/repositoris/message/message_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'message_history.g.dart';

@riverpod
class MessageHistory extends _$MessageHistory {
  final historyRepo = MessageRepo();
  @override
  List<Users> build() => [];
  Future<void> getMessageHistory() async {
    ref.read(loadingDataMessage.notifier).state = true;
    try {
      final data = await historyRepo
          .getOtherUserId()
          .then((value) async => await historyRepo.getUser(value));
      state.clear();
      state.addAll(data);
    } catch (e) {
      rethrow;
    } finally {
      ref.read(loadingDataMessage.notifier).state = false;
    }
  }
}

final loadingDataMessage = StateProvider((ref) => false);
