import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/place.dart';
import '../../../data/repositoris/places_rep.dart';

final placeProvider = StateNotifierProvider<PlaceProvider, List<Place>>(
    (ref) => PlaceProvider([], ref));

class PlaceProvider extends StateNotifier<List<Place>> {
  final Ref ref;

  PlaceProvider(super.state, this.ref);

  final placeRepository = PlacesRepository();

  Future<List<Place>> getPlaces() async {
    final newPlaces = await placeRepository.fetchPlaces();
    state = newPlaces;

    return state;
  }

  Future<Place?> fetchSinglePlace(String id) async {
    final database = FirebaseFirestore.instance;
    try {
      final querySnapshot = await database.collection('Places').doc(id).get();
      final place = Place.fromJson(querySnapshot.data()!);
      return place;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
