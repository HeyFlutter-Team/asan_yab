import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageSeen {
  Future<List<bool>> newMessage() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      if (uid.isNotEmpty) {
        var querySnapshot = await FirebaseFirestore.instance
            .collection('User')
            .doc(uid)
            .collection('chat')
            .orderBy('times', descending: true)
            .get();

        // Check if the querySnapshot has data
        if (querySnapshot.docs.isNotEmpty) {
          // Extract message states from document snapshots
          final states = querySnapshot.docs
              .map((doc) => doc.data()['last_message'] as bool)
              .toList();
          print("Message States: $states");
          return states;
        } else {
          print("No messages found");
          return [];
        }
      } else {
        print("User ID is empty");
        return [];
      }
    } catch (e) {
      print("Error retrieving message states: $e");
      rethrow; // Rethrow the exception
    }
  }

  Future<void> updateSeenMessage(String receiverId, String uid) async {
    try {
      print("Updating message seen status for receiver $receiverId");
      await FirebaseFirestore.instance
          .collection('User')
          .doc(uid)
          .collection('chat')
          .doc(receiverId)
          .update({'last_message': false});
    } catch (e) {
      print("Error updating message seen status: $e");
      rethrow; // Rethrow the exception
    }
  }
}
