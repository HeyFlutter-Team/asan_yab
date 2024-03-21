import 'package:asan_yab/data/repositoris/message/message_seen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final seenMassageProvider =
    StateNotifierProvider<SeenMassage, List<bool>>((ref) => SeenMassage([]));

class SeenMassage extends StateNotifier<List<bool>> {
  SeenMassage(super.state);
  final lastMessageRepo = MessageSeen();

  Future<void> isNewMassage() async {
    state = await lastMessageRepo.newMessage();
  }

  Future<void> messageIsSeen(
    String receiverId,
    String uid,
  ) async {
    await lastMessageRepo.updateSeenMessage(receiverId, uid);
  }
}
