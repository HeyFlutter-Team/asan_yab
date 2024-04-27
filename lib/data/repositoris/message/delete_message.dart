import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteEditMessage {
  Future<void> deleteMessageForMe(
      String uid, String receiverId, String messageContent,String messageSentTime) async {
    FirebaseFirestore.instance
        .collection('User')
        .doc(uid)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .where("content", isEqualTo: messageContent)
        .get()
        .then((query) {
      for (QueryDocumentSnapshot docSnapshot in query.docs) {
        docSnapshot.reference.delete();
      }
    });
  }
  Future<void> deleteMessageForAll(
      String uid, String receiverId, String messageContent,String messageSentTime) async {
    FirebaseFirestore.instance
        .collection('User')
        .doc(uid)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .where("content", isEqualTo: messageContent)
        .get()
        .then((query) {
      for (QueryDocumentSnapshot docSnapshot in query.docs) {
        docSnapshot.reference.delete();
      }
    });
    print('step done 1');
    FirebaseFirestore.instance
        .collection('User')
        .doc(receiverId)
        .collection('chat')
        .doc(uid)
        .collection('messages')
        .where("content", isEqualTo: messageContent)
        .get()
        .then((query) {
      for (QueryDocumentSnapshot docSnapshot in query.docs) {
        docSnapshot.reference.delete();
      }
    });
    print('step done 2');
  }
  Future<void> editMessageForMe(
      String uid,
      String receiverId,
      String oldMessageContent,
      String newMessageContent,
      String messageSentTime) async {
    try {
      // Update messages in sender's collection
      final senderQuerySnapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(uid)
          .collection('chat')
          .doc(receiverId)
          .collection('messages')
          .where("content", isEqualTo: oldMessageContent)
          .get();

      for (QueryDocumentSnapshot docSnapshot in senderQuerySnapshot.docs) {
        final messageDocRef = docSnapshot.reference;
        if (oldMessageContent != newMessageContent) {
          await messageDocRef.update({
            'content': newMessageContent,
            'isMessageEdited': true,
          });
        }
      }

      // Update messages in receiver's collection
      final receiverQuerySnapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(receiverId)
          .collection('chat')
          .doc(uid)
          .collection('messages')
          .where("content", isEqualTo: oldMessageContent)
          .get();

      for (QueryDocumentSnapshot docSnapshot in receiverQuerySnapshot.docs) {
        final messageDocRef = docSnapshot.reference;
        if (oldMessageContent != newMessageContent) {
          await messageDocRef.update({
            'content': newMessageContent,
            'isMessageEdited': true,
          });
        }
      }
    } catch (e) {
      print('Error editing message: $e');
      // Handle error
    }
  }



}
