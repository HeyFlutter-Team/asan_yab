import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/place.dart';

final getSingleProvider = StateNotifierProvider<SingleProvider, Place?>(
    (ref) => SingleProvider(null));

class SingleProvider extends StateNotifier<Place?> {
  SingleProvider(super.state);

  Future fetchSinglePlace(String id) async {
    final database = FirebaseFirestore.instance;
    try {
      final querySnapshot = await database.collection('NewPlaces').doc(id).get();

      final place = Place.fromJson(querySnapshot.data()!);
      state = place;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
