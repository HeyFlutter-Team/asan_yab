
import 'package:asan_yab/database/firebase_helper/place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class PlaceReponse {
 final List<Place> docs;
  final DocumentSnapshot? lastItem;
  final int totalItem;

 PlaceReponse({
    required this.docs,
     this.lastItem,
    required this.totalItem,
  });

}
