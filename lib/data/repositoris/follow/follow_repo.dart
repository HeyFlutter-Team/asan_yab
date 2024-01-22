import 'package:asan_yab/data/models/follow_user/follow_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class FollowRepo {
  Future<void> newUser(String id, FollowModel followModel) async {
    await FirebaseFirestore.instance
        .collection('User')
        .doc(id)
        .collection('Follow')
        .doc(id)
        .set(followModel.toJson());
  }

  Future<void> updateFollowers(String uid, String followId) async {
    final String cloudFunctionUrl =
        "https://us-central1-asan-yab.cloudfunctions.net/app/api/update/$uid?followId=$followId";
    try {
      final response = await http.put(
        Uri.parse(cloudFunctionUrl),
      );

      if (response.statusCode == 200) {
        // Successfully called Cloud Function
        print("Cloud Function response: ${response.body}");
      } else {
        // Cloud Function call failed
        print("Error calling Cloud Function: ${response.statusCode}");
        print("Error message: ${response.body}");
      }
    } catch (e) {
      // Handle any exceptions during the HTTP request
      print("Error: $e");
    }
  }
}
