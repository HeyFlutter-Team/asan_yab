import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/firebase_collection_names.dart';
import '../../../data/models/place.dart';

final getSingleProvider = StateNotifierProvider<SinglePlaceProvider, Place?>(
    (ref) => SinglePlaceProvider(null));

class SinglePlaceProvider extends StateNotifier<Place?> {
  SinglePlaceProvider(super.state);

  Future fetchSinglePlace(String id) async {
    final database = FirebaseFirestore.instance;
    try {
      final querySnapshot = await database
          .collection(FirebaseCollectionNames.places)
          .doc(id)
          .get();

      final place = Place.fromJson(querySnapshot.data()!);
      state = place;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
