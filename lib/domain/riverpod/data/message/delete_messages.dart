import 'package:asan_yab/data/repositoris/message/delete_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deleteMessagesProvider =
    StateNotifierProvider((ref) => DeleteMessages(ref));

class DeleteMessages extends StateNotifier {
  DeleteMessages(super.state);
  final deleteMessageRepo = const DeleteMessage();
  Future<void> deleteSingleMessage(
    String uid,
    String receiverId,
    String messageContent,
  ) async => deleteMessageRepo.deleteMessage(uid, receiverId, messageContent);
}
