import 'package:asan_yab/data/models/users.dart';
import 'package:asan_yab/data/repositoris/message/message_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../data/models/message/message.dart';
import 'message_data.dart';

final messageProfileProvider = StateNotifierProvider<MessageProvider, Users?>(
    (ref) => MessageProvider(null));

class MessageProvider extends StateNotifier<Users?> {
  MessageProvider(super.state);
  final messageRepo = MessageRepo();
  final textController = TextEditingController();
  final FocusNode focusNode = FocusNode();
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
      debugPrint('getUserById 1');
      loading = true;
      firebase
          .collection('User')
          .doc(uid)
          .snapshots(includeMetadataChanges: true)
          .listen((user) {
        state = Users.fromMap(user.data()!);
      });
      debugPrint('test get user ${state!.name}');
      debugPrint('getUserById 2');
      return state!;
    } catch (e) {
      rethrow;
    } finally {
      loading = false;
    }
  }

  Future<void> sendText(
      {required String receiverId,
      required BuildContext context,
      required replayMessage,
        required replayMessageIndex,
        required replayIsMine,
        required replayMessageTime,
required WidgetRef ref,
        required messageEditedProvider,
        required Users users
      }) async {
    try {
      debugPrint('sendText 1');
      if (textController.text.isNotEmpty) {
         messageRepo.addTextMessage(
            content: textController.text,
            receiverId: receiverId,
            replayMessage: replayMessage,
            replayMessageIndex: replayMessageIndex,
            replayIsMine: replayIsMine,
           messageEditedProvider: messageEditedProvider,
           replayMessageTime: replayMessageTime,
           ref: ref
        );
         ref
             .read(messageProvider.notifier)
             .scrollDown(ref
             .watch(messageProvider)
             .length);

         debugPrint('younis message sent2');


         debugPrint('sendText 2');
      }
    } catch (e) {
      return debugPrint(e.toString());
    }
  }

  Future<void> sendSticker({
    required String receiverId,
    required BuildContext context,
    required int currentUserCoinCount,
    required double scrollPositioned,
    required String gifUrl,
  }) async {
    try {
      debugPrint('sendSticker 1');
      await messageRepo.addStickerMessage(
        receiverId: receiverId,
        currentUserCoinCount: currentUserCoinCount,
        content: gifUrl,
      );
      debugPrint('sendSticker 2');
    } catch (e) {
      return debugPrint(e.toString());
    } finally {
      FocusScope.of(context).unfocus();
    }
  }
}

final emojiShowingProvider = StateProvider((ref) => false);
final gifShowingProvider = StateProvider((ref) => false);
final hasTextFieldValueProvider = StateProvider((ref) => false);
final replayProvider = StateProvider((ref) => '');
final messageIndexProvider = StateProvider<int>((ref) => 0);
final replayMessageTimeProvider = StateProvider((ref) => '');
final replayIsMineProvider = StateProvider((ref) => false);
final showMenuOpenedProvider = StateProvider((ref) => false);
final isMessageEditing = StateProvider((ref) => false);
final messageEditedProvider = StateProvider((ref) => false);
final activeChatIdProvider = StateProvider((ref) => '');
final isUnreadMessageProvider = StateProvider((ref) => false);
final localMessagesProvider = StateProvider<List<MessageModel>>((ref) => []);


class EditingMessageDetailsNotifier extends StateNotifier<MessageModel> {
  EditingMessageDetailsNotifier(MessageModel initialState)
      : super(initialState);

  void setContent(String newContent) {
    state = state.copyWith(content: newContent);
  }
}
final editingMessageDetails = StateNotifierProvider<EditingMessageDetailsNotifier, MessageModel>((ref) {
  return EditingMessageDetailsNotifier(MessageModel(
    senderId: '',
    receiverId: '',
    content: '',
    sentTime: DateTime.now(),
    messageType: MessageType.text,
    replayMessage: '',
    isSeen: false,
    replayMessageIndex: 0,
    replayIsMine: false,
    isMessageEdited: false,
    replayMessageTime: ''
  ));
});



class WallpaperStateNotifier extends StateNotifier<String> {
  WallpaperStateNotifier() : super('assets/wallpaper_6_main.jpg');

  Future<void> loadInitialWallpaperPath() async {
    String? initialWallpaperPath = await _loadWallpaperPath();
    if (initialWallpaperPath != null) {
      state = initialWallpaperPath;
    }
  }

  Future<void> saveWallpaperPath(String wallpaperPath) async {
    await _saveWallpaperPath(wallpaperPath);
    state = wallpaperPath;
  }

  Future<String?> _loadWallpaperPath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedWallpaper');
  }

  Future<void> _saveWallpaperPath(String wallpaperPath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedWallpaper', wallpaperPath);
  }
}

final wallpaperStateNotifierProvider =
StateNotifierProvider<WallpaperStateNotifier, String>((ref) {
  return WallpaperStateNotifier()..loadInitialWallpaperPath();
});