import 'package:asan_yab/database/firebase_helper/place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlacesRepository {
  final firebase = FirebaseFirestore.instance;
  final _path = 'Places';

  Future<List<Place>> fetchPlaces() async {
    try {
      final data = await firebase.collection(_path).orderBy('createdAt', descending: true).get();
      final categories = data.docs
                    .map((doc) => Place.fromJson(doc.data()))
                    .toList();
return categories;
    }catch (e){
      return [];
    }
  }
}