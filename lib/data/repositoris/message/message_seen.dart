import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageSeen {
  Future<List<bool>> newMessage() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      var documentSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(uid)
          .collection('chat')
          .orderBy('times', descending: true)
          .get();

      // Check if the document exists
      final data = documentSnapshot.docs
          .map((e) => e.data()['last_message'] as bool)
          .toList();

      // Check if the 'last_message' field exists in the document
      // final lastMessage = data['last_message'];
      print("Last Message: $data");
      return data;
    } catch (e) {
      print("Error retrieving document: $e");
      rethrow;
    }
  }

  Future<void> updateSeenMessage(String receiverId, String uid) async {
    print("receiverId:$receiverId and uid:$uid");
    await FirebaseFirestore.instance
        .collection('User')
        .doc(uid)
        .collection('chat')
        .doc(receiverId)
        .update({'last_message': false});
  }
}
