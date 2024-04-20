import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/firebase_collection_names.dart';
import '../../../data/models/place.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'single_place.g.dart';

@riverpod
class SinglePlace extends _$SinglePlace {
  @override
  Place? build() => null;
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
