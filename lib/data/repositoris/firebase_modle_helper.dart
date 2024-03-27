import 'package:asan_yab/data/models/suggestion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class FirebaseSuggestionCreate {
  Future createSuggestion(
      String name, String address, String phoneNum, String type) async {
    final idTime = getId();
    final suggestionRef =
        FirebaseFirestore.instance.collection('Suggestion').doc(idTime);
    final suggestion = SuggestionFirebase(
        id: idTime, name: name, address: address, phone: phoneNum, type: type);
    final json = suggestion.toJson();
    suggestionRef.set(json);
  }

  String getId() {
    final DateTime now = DateTime.now();
    final String timestamp = DateFormat('yyyyMMddHHmmss').format(now);
    return timestamp;
  }

  Future<void> updateOnlineStatus(bool isOnline) async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        await FirebaseFirestore.instance
            .collection('User')
            .doc(userId)
            .update({
          'isOnline': isOnline,
          'fcmToken': 'token' // assuming this is a placeholder
        });
      } else {
        throw Exception('User not authenticated');
      }
    } catch (e) {
      print('Error updating online status: $e');
      // Handle error
    }
  }
  Future<void> signOut() async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.signOut();
      } else {
        print("Current user is already null");
      }
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}
