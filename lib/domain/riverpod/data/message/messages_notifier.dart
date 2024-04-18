import 'package:asan_yab/data/models/message/message_model.dart';
import 'package:asan_yab/data/repositoris/message/message_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'messages_notifier.g.dart';

@riverpod
class MessagesNotifier extends _$MessagesNotifier {
  final messageRepo = MessageRepo();
  @override
  List<MessageModel> build() => [];
  Future<void> fetchMessage() async {
    ref.read(loadingMessagesNotifier.notifier).state = true;
    try {
      final data = await messageRepo
          .getOtherUserId()
          .then((value) async => await messageRepo.getLastMessage(value));
      state.clear();
      state = data;
    } catch (e) {
      rethrow;
    } finally {
      ref.read(loadingMessagesNotifier.notifier).state = false;
    }
  }

  Future<void> deleteSingleMessage(
    String uid,
    String receiverId,
    String messageContent,
  ) async =>
      messageRepo.deleteMessage(uid, receiverId, messageContent);
}

final loadingMessagesNotifier = StateProvider((ref) => false);
