import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messageProfileProvider =
    StateNotifierProvider((ref) => MessageProvider(ref));

class MessageProvider extends StateNotifier {
  MessageProvider(super.state);

  final textController = TextEditingController();
  bool loading = true;

  onBackspacePressed() {
    textController
      ..text = textController.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: textController.text.length));
  }
  //
  // Future<UserModel> getUserById(String uid) async {
  //   final firebase = FirebaseFirestore.instance;
  //
  //   try {
  //     loading = true;
  //     firebase
  //         .collection('Users')
  //         .doc(uid)
  //         .snapshots(includeMetadataChanges: true)
  //         .listen((user) {
  //       state = UserModel.fromJson(user.data()!);
  //     });
  //     debugPrint('test get user ${state.fullName}');
  //     return state;
  //   } catch (e) {
  //     rethrow;
  //   } finally {
  //     loading = false;
  //   }
  // }
  //
  // Future<void> sendText(
  //     {required String receiverId, required BuildContext context}) async {
  //   try {
  //     if (textController.text.isNotEmpty) {
  //       await messageRepo.addTextMessage(
  //           content: textController.text, receiverId: receiverId);
  //       // textController.clear();
  //       // FocusScope.of(context).unfocus();
  //     }
  //   } catch (e) {
  //     return print(e.toString());
  //   } finally {
  //     if (mounted) {
  //       // FocusScope.of(context).unfocus();
  //     }
  //   }
  // }
}

final emojiShowingProvider = StateProvider((ref) => false);
