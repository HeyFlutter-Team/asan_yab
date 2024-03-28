import 'package:asan_yab/data/models/follow_user/follow_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/firebase_collection_names.dart';

class FollowRepo {
  const FollowRepo();
  Future<void> newUser(String id, FollowModel followModel) async {
    await FirebaseFirestore.instance
        .collection(FirebaseCollectionNames.user)
        .doc(id)
        .collection(FirebaseCollectionNames.follow)
        .doc(id)
        .set(followModel.toJson());
  }

  Future<void> updateFollowers(String uid, String followId) async {
    final cloudFunctionUrl =
        "https://us-central1-asan-yab.cloudfunctions.net/app/api/update/$uid?followId=$followId";
    try {
      final response = await http.put(Uri.parse(cloudFunctionUrl));

      if (response.statusCode == 200) {
        // Successfully called Cloud Function
        debugPrint("Cloud Function response: ${response.body}");
      } else {
        // Cloud Function call failed
        debugPrint("Error calling Cloud Function: ${response.statusCode}");
        debugPrint("Error message: ${response.body}");
      }
    } catch (e) {
      // Handle any exceptions during the HTTP request
      debugPrint("Error: $e");
    }
  }
}
