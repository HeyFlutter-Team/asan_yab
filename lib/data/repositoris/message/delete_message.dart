import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firebase_collection_names.dart';

class DeleteMessage {
  const DeleteMessage();
  Future<void> deleteMessage(
    String uid,
    String receiverId,
    String messageContent,
  ) async {
    FirebaseFirestore.instance
        .collection(FirebaseCollectionNames.user)
        .doc(uid)
        .collection(FirebaseCollectionNames.chat)
        .doc(receiverId)
        .collection(FirebaseCollectionNames.message)
        .where("content", isEqualTo: messageContent)
        .get()
        .then((query) {
      for (final docSnapshot in query.docs) {
        docSnapshot.reference.delete();
      }
    });
  }
}
