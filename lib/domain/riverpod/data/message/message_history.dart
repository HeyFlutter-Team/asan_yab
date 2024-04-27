import 'package:asan_yab/data/models/users.dart';
import 'package:asan_yab/data/repositoris/message/history_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messageHistory = StateNotifierProvider<MessageHistory, List<Users>>(
    (ref) => MessageHistory([], ref));

class MessageHistory extends StateNotifier<List<Users>> {
  MessageHistory(super.state, this.ref);
  final Ref ref;
  final historyRepo = HistoryMessage();

  Future<void> getMessageHistory() async {
    ref.read(loadingDataMessage.notifier).state = true;
    try {
      print('getMessageHistory 1');
      final data = await historyRepo
          .getOtherUserId()
          .then((value) async => await historyRepo.getUser(value));
      state.clear();
      state.addAll(data);
      print('getMessageHistory 2');
    } catch (e) {
      rethrow;
    } finally {
      ref.read(loadingDataMessage.notifier).state = false;
    }
  }
}

final loadingDataMessage = StateProvider((ref) => false);
