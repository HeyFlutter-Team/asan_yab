import 'dart:convert';

import 'package:asan_yab/data/models/place.dart';
import 'package:asan_yab/presentation/pages/search_notifire.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

class HttpGetPost {
  final Ref ref;
  const HttpGetPost(this.ref);

  Future<List<Place>> getUser() async {
    final data = ref.watch(searchNotifierProvider);
    final endPoint =
        'https://us-central1-asan-yab.cloudfunctions.net/SearchPlace?pivot=$data';
    final response = await get(Uri.parse(endPoint));
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      var rest = result["filteredList"] as List;
      return rest.map(((e) => Place.fromJson(e))).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}

final userProvider = Provider<HttpGetPost>((ref) => HttpGetPost(ref));
