import 'package:asan_yab/data/repositoris/message/delete_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deleteEditMessagesProvider =
    StateNotifierProvider((ref) => DeleteEditMessagesNo(ref));

class DeleteEditMessagesNo extends StateNotifier {
  DeleteEditMessagesNo(super.state);
  final deleteEditMessageRepo = DeleteEditMessage();
  Future<void> deleteSingleMessageForMe(String uid, String receiverId,
      String messageContent, String messageSentTime) async {
    deleteEditMessageRepo.deleteMessageForMe(
        uid, receiverId, messageContent, messageSentTime);
  }

  Future<void> deleteSingleMessageForAll(String uid, String receiverId,
      String messageContent, String messageSentTime) async {
    deleteEditMessageRepo.deleteMessageForAll(
        uid, receiverId, messageContent, messageSentTime);
  }

  Future<void> editMessage(
      String uid,
      String receiverId,
      String oldMessageContent,
      String newMessageContent,
      String messageSentTime) async {
    deleteEditMessageRepo.editMessageForMe(
        uid, receiverId, oldMessageContent, newMessageContent, messageSentTime);
  }
}
