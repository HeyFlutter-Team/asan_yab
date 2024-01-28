import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteMessage {
  Future<void> deleteMessage(
      String uid, String receiverId, String messageContent) async {
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
}
