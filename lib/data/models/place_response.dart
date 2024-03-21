import 'package:asan_yab/data/models/place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceResponse {
  final List<Place> docs;
  final DocumentSnapshot? lastItem;
  final int totalItem;

  const PlaceResponse({
    required this.docs,
    this.lastItem,
    required this.totalItem,
  });
}
