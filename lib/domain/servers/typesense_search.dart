import 'package:asan_yab/data/models/search_model.dart';
import 'package:flutter/material.dart';
import 'package:typesense/typesense.dart';

import '../../core/constants/firebase_collection_names.dart';

class TypesenseSearch {
  // ignore: prefer_typing_uninitialized_variables
  late final Configuration config;
  // ignore: prefer_typing_uninitialized_variables
  late final Client client;

  //constructor to initilize client
  TypesenseSearch() {
    config = Configuration(
      '8IW8Vtvr2d99tU6No3KCcnjtoHqrPPx1', //api key from text file
      nodes: {
        Node(
          Protocol.https, // For Typesense Cloud use https
          "a3dj2cfs1gmi58b6p-1.a1.typesense.net", // For Typesense Cloud use xxx.a1.typesense.net
          port: 443, // For Typesense Cloud use 443
        ),
      },
      connectionTimeout: const Duration(seconds: 20),
    );
    client = Client(config);
  }

  //function to search
  Future<List<SearchModel>> searchForData(String data) async {
    List<SearchModel> placesList = [];
    final searchParameters = {
      'q': data,
      'query_by': 'name',
    };
    try {
      final result = await client
          .collection(FirebaseCollectionNames.places)
          .documents
          .search(searchParameters);

      // print(result);
      final data = result["hits"];
      for (var documents in data) {
        final x = documents["document"];
        final obj =
            SearchModel(id: x["id"], name: x["name"], imageUrl: x['logo']);

        placesList.add(obj);
      }
      return placesList;
    } catch (e) {
      debugPrint("ERROR while SEARCH=$e");
      return placesList;
    }
  }
}
