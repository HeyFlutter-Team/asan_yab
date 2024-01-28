import 'package:asan_yab/data/models/message/message.dart';
import 'package:asan_yab/data/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageRepo {
  final firebase = FirebaseFirestore.instance;
  Users? user;
  Future<void> addTextMessage({
    required String content,
    required String receiverId,
    required String replayMessage,
  }) async {
    try {
      final message = MessageModel(
        senderId: FirebaseAuth.instance.currentUser!.uid,
        receiverId: receiverId,
        content: content,
        sentTime: DateTime.now().toUtc(),
        messageType: MessageType.text,
        replayMessage: replayMessage,
      );
      await addMessageToChat(receiverId: receiverId, message: message);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> addStickerMessage({
    required String content,
    required String receiverId,
    required int currentUserCoinCount,
    String? replayMessage,
  }) async {
    try {
      final message = MessageModel(
        senderId: FirebaseAuth.instance.currentUser!.uid,
        receiverId: receiverId,
        content: content,
        sentTime: DateTime.now().toUtc(),
        messageType: MessageType.sticker,
        replayMessage: replayMessage ?? '',
      );
      await addMessageToChat(receiverId: receiverId, message: message);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> addMessageToChat({
    required String receiverId,
    required MessageModel message,
  }) async {
    await FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chat')
        .doc(receiverId)
        .set({
      'uid': receiverId,
      'times': Timestamp.now(),
      "last_message": true
    });
    await FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .add(message.toJson());

    await FirebaseFirestore.instance
        .collection('User')
        .doc(receiverId)
        .collection('chat')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'times': Timestamp.now(),
      'last_message': true,
    });
    await FirebaseFirestore.instance
        .collection('User')
        .doc(receiverId)
        .collection('chat')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('messages')
        .add(message.toJson());
  }

  // Future<UserModel?> getUserById(String? uid) async {
  //   try {
  //     print('in repo our uid ${uid}');
  //     firebase
  //         .collection('Users')
  //         .doc(uid)
  //         .snapshots(includeMetadataChanges: true)
  //         .listen((user) {
  //       this.user = UserModel.fromJson(user.data()!);
  //     });
  //     return user;
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     rethrow;
  //   }
  // }
  //
  // List<MessageModel> getMessages(
  //     String receiverId, List<MessageModel> messageModel) {
  //   FirebaseFirestore.instance
  //       .collection('Users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .collection('chat')
  //       .doc(receiverId)
  //       .collection('messages')
  //       .orderBy('sentTime', descending: false)
  //       .snapshots(includeMetadataChanges: true)
  //       .listen((messages) {
  //     messageModel = messages.docs
  //         .map((doc) => MessageModel.fromJson(doc.data()))
  //         .toList();
  //   });
  //   return messageModel;
  // }
}
