import 'package:asan_yab/data/models/users.dart';
import 'package:asan_yab/data/repositoris/message/message_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messageProfileProvider = StateNotifierProvider<MessageProvider, Users?>(
    (ref) => MessageProvider(null));

class MessageProvider extends StateNotifier<Users?> {
  MessageProvider(super.state);
  final messageRepo = MessageRepo();
  final textController = TextEditingController();
  bool loading = true;

  onBackspacePressed() {
    textController
      ..text = textController.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: textController.text.length));
  }

  Future<Users> getUserById(String uid) async {
    final firebase = FirebaseFirestore.instance;
    try {
      loading = true;
      firebase
          .collection('User')
          .doc(uid)
          .snapshots(includeMetadataChanges: true)
          .listen((user) {
        state = Users.fromMap(user.data()!);
      });
      debugPrint('test get user ${state!.name}');
      return state!;
    } catch (e) {
      rethrow;
    } finally {
      loading = false;
    }
  }

  Future<void> sendText({
    required String receiverId,
    required BuildContext context,
    required replayMessage,
  }) async {
    try {
      if (textController.text.isNotEmpty) {
        await messageRepo.addTextMessage(
            content: textController.text,
            receiverId: receiverId,
            replayMessage: replayMessage);
        // textController.clear();
        // FocusScope.of(context).unfocus();
      }
    } catch (e) {
      return debugPrint(e.toString());
    } finally {
      if (mounted) {
        // FocusScope.of(context).unfocus();
      }
    }
  }

  Future<void> sendSticker({
    required String receiverId,
    required BuildContext context,
    required int currentUserCoinCount,
  }) async {
    try {
      await messageRepo.addStickerMessage(
        receiverId: receiverId,
        currentUserCoinCount: currentUserCoinCount,
        content: '',
      );
    } catch (e) {
      return print(e.toString());
    } finally {
      FocusScope.of(context).unfocus();
    }
  }
}

final emojiShowingProvider = StateProvider((ref) => false);
final replayProvider = StateProvider((ref) => '');
