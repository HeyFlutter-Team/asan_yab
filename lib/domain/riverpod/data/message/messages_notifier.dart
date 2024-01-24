import 'package:asan_yab/data/models/message/message.dart';
import 'package:asan_yab/data/repositoris/message/history_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messageNotifierProvider =
    StateNotifierProvider<MessagesNotifier, List<MessageModel>>(
        (ref) => MessagesNotifier([], ref));

class MessagesNotifier extends StateNotifier<List<MessageModel>> {
  final Ref ref;
  MessagesNotifier(super.state, this.ref);
  final historyRepo = HistoryMessage();

  Future<void> fetchMessage() async {
    ref.read(loadingMessagesNotifier.notifier).state = true;
    try {
      final data = await historyRepo
          .getOtherUserId()
          .then((value) async => await historyRepo.getLastMessage(value));
      state.clear();
      state = data;
    } catch (e) {
      rethrow;
    } finally {
      ref.read(loadingMessagesNotifier.notifier).state = false;
    }

    // String messageDateFormat(DateTime dateTime) {
    //   DateTime now = DateTime.now();
    //   DateTime today = DateTime(now.year, now.month, now.day);
    //   DateTime yesterday = DateTime(now.year, now.month, now.day - 1);
    //   if (dateTime.compareTo(today) >= 0) {
    //     return DateFormat('h:mm:a').format(dateTime);
    //   } else if (dateTime.compareTo(yesterday) >= 0) {
    //     return 'Yesterday';
    //   } else {
    //     return DateFormat('MM/dd/yy').format(dateTime);
    //   }
    // }
  }
}

final loadingMessagesNotifier = StateProvider((ref) => false);
