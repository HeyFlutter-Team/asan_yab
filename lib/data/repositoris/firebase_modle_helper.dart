import 'package:asan_yab/data/models/suggestion.dart';
import 'package:asan_yab/domain/riverpod/data/profile_data_provider.dart';
import 'package:asan_yab/presentation/pages/search_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class FirebaseSuggestionCreate {
  Future createSuggestion(
      String placeName, String location, String userPhone, String locationDescription,WidgetRef ref) async {
    final idTime = getId();
    final suggestionRef =
        FirebaseFirestore.instance.collection('Suggestion').doc(idTime);
    final userDetails = ref.watch(userDetailsProvider);
    final String timestamp = DateFormat('yyyy/MM/dd/HH/mm/ss').format(DateTime.now());
    final suggestion = SuggestionModel(
      id:idTime ,
      userId:'${userDetails?.id}' ,
      location:location ,
      locationDescription: locationDescription,
      placeName:placeName ,
      sentTime:timestamp,
      userImage:'${userDetails?.imageUrl}' != ''&&
          userDetails!.imageUrl.isNotEmpty
          ?userDetails.imageUrl
          :'https://firebasestorage.googleapis.com/v0/b/asan-yab.appspot.com/o/files%2F4lGHDOM2bNQsvaOtg9l2Afkc2UC2%2Fimage_cropper_1713421490088.jpg?alt=media&token=c5710d57-99e3-4e7a-9f19-24bfef86eacf' ,
      userName: '${userDetails?.name}',
      userPhone:userPhone ,
    );
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
