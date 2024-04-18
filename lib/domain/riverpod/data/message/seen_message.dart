import 'package:asan_yab/data/repositoris/message/message_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'seen_message.g.dart';

@Riverpod(keepAlive: true)
class SeenMassage extends _$SeenMassage {
  final messageRepo = MessageRepo();
  @override
  List<bool> build() => [];

  Future<void> isNewMassage() async => state = await messageRepo.newMessage();

  Future<void> messageIsSeen(
    String receiverId,
    String uid,
  ) async =>
      await messageRepo.updateSeenMessage(receiverId, uid);
}
