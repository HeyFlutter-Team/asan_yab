import 'dart:convert';

import 'package:asan_yab/data/models/place.dart';
import 'package:asan_yab/domain/riverpod/data/search_place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

class HttpGetPostSearch {
  final Ref ref;
  const HttpGetPostSearch(this.ref);

  Future<List<Place>> getUser() async {
    final data = ref.watch(searchPlaceProvider);
    final endPoint =
        'https://us-central1-asan-yab.cloudfunctions.net/SearchPlace?pivot=$data';
    final response = await get(Uri.parse(endPoint));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      final rest = result["filteredList"] as List;
      return rest.map(((e) => Place.fromJson(e))).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}

final userProvider =
    Provider<HttpGetPostSearch>((ref) => HttpGetPostSearch(ref));
