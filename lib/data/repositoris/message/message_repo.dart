import 'package:asan_yab/data/models/message/message.dart';
import 'package:asan_yab/data/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/riverpod/data/message/message.dart';

class MessageRepo {
  final firebase = FirebaseFirestore.instance;
  Users? user;
  Future<void> addTextMessage(
      {required String content,
      required String receiverId,
      required String replayMessage,
      bool? isSeen,
        bool? replayIsMine,
        bool? messageEditedProvider,
        required int replayMessageIndex,
      required String replayMessageTime,
        required WidgetRef ref
      }) async {
    try {
      print('addTextMessage 1');
      final message = MessageModel(
          senderId: FirebaseAuth.instance.currentUser!.uid,
          receiverId: receiverId,
          content: content,
          sentTime: DateTime.now().toUtc(),
          messageType: MessageType.text,
          replayMessage: replayMessage,
          isSeen: isSeen ?? false,
          replayMessageIndex: replayMessageIndex,
        replayIsMine: replayIsMine ?? false,
        isMessageEdited: messageEditedProvider ?? false,
        replayMessageTime: replayMessageTime
      );
      await addMessageToChat(receiverId: receiverId, message: message);
      print('addTextMessage 2');
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> addStickerMessage(
      {required String content,
      required String receiverId,
      required int currentUserCoinCount,
      String? replayMessage,
      bool? isSeen,
        bool?replayIsMine,
        int? replayMessageIndex,
        bool? messageEditedProvider,
        String? replayMessageTime
      }) async {
    try {
      print('addStickerMessage 1');
      final message = MessageModel(
          senderId: FirebaseAuth.instance.currentUser!.uid,
          receiverId: receiverId,
          content: content,
          sentTime: DateTime.now().toUtc(),
          messageType: MessageType.sticker,
          replayMessage: replayMessage ?? '',
          isSeen: isSeen ?? false,
          replayMessageIndex: replayMessageIndex??0,
          replayIsMine: replayIsMine ?? false,
        isMessageEdited: messageEditedProvider ?? false,
        replayMessageTime: replayMessageTime ?? ''
      );
      await addMessageToChat(receiverId: receiverId, message: message);
      print('addStickerMessage 2');
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> addMessageToChat({
    required String receiverId,
    required MessageModel message,
  }) async {
    print('addMessageToChat 1');
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
    print('addMessageToChat 2');
  }

  Future<void> markMessageAsSeen(String userId) async {
    try {
      print('markMessageAsSeen 1');
      String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
      print('Current User ID: $currentUserId');
      CollectionReference messagesRef = FirebaseFirestore.instance
          .collection('User')
          .doc(currentUserId)
          .collection('chat')
          .doc(userId)
          .collection('messages');
      QuerySnapshot messagesSnapshot = await messagesRef.where('isSeen', isEqualTo: false).get();
      print('Total Messages to Process: ${messagesSnapshot.size}');

      for (DocumentSnapshot messageDoc in messagesSnapshot.docs) {
        Map<String, dynamic> messageData = messageDoc.data() as Map<String, dynamic>;
        String senderId = messageData['senderId'] ?? '';
        print('Sender ID: $senderId');
        //new

        if (senderId != currentUserId) {
           messageDoc.reference.update({'isSeen': true});
          print('Message marked as seen: ${messageDoc.id}');
        } else {
          print('Message sender is current user. Skipping...');
        }
      }

      //new
      CollectionReference userRef = FirebaseFirestore.instance
          .collection('User')
          .doc(userId)
          .collection('chat')
          .doc(currentUserId)
          .collection('messages');
      QuerySnapshot userSnapshot = await userRef.where('isSeen', isEqualTo: false).get();
      for (DocumentSnapshot userDoc in userSnapshot.docs) {
        Map<String, dynamic> messageData = userDoc.data() as Map<String, dynamic>;
        String senderId = messageData['senderId'] ?? '';
        if (senderId != currentUserId) {
           userDoc.reference.update({'isSeen': true});
        } else {
        }
      }

      print('markMessageAsSeen 2');
      print('All messages marked as seen successfully');
    } catch (error) {
      print('Error marking messages as seen: $error');
    }
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
