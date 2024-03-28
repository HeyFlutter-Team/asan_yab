import 'package:asan_yab/data/models/user_suggestion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../core/constants/firebase_collection_names.dart';

class FirebaseSuggestionCreate {
  const FirebaseSuggestionCreate();
  Future createSuggestion(
    String name,
    String address,
    String phoneNum,
    String type,
  ) async {
    final idTime = getId();
    final suggestionRef = FirebaseFirestore.instance
        .collection(FirebaseCollectionNames.suggestion)
        .doc(idTime);
    final suggestion = UserSuggestion(
      id: idTime,
      name: name,
      address: address,
      phone: phoneNum,
      type: type,
    );
    final json = suggestion.toJson();
    suggestionRef.set(json);
  }

  String getId() {
    final now = DateTime.now();
    final timestampAsId = DateFormat('yyyyMMddHHmmss').format(now);
    return timestampAsId;
  }
}
