import 'package:asan_yab/data/models/typesenses_models.dart';
import 'package:typesense/typesense.dart';

class SearchInstance {
  // ignore: prefer_typing_uninitialized_variables
  late final Configuration config;
  // ignore: prefer_typing_uninitialized_variables
  late final Client client;

  //constructor to initilize client
  SearchInstance() {
    config = Configuration(
      'Nv5QMjIHPQe4tpXR5VGbIFOi8naPyXgy', //api key from text file
      nodes: {
        Node(
          Protocol.https, // For Typesense Cloud use https
          "yn9pmsvhj82fw4qlp-1.a1.typesense.net", // For Typesense Cloud use xxx.a1.typesense.net
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
      final result =
          await client.collection('places').documents.search(searchParameters);

      // print(result);
      final data = result["hits"];
      for (var documents in data) {
        final x = documents["document"];
        SearchModel obj =
            SearchModel(id: x["id"], name: x["name"], imageUrl: x['logo']);

        placesList.add(obj);
      }
      return placesList;
    } catch (e) {
      print("ERROR while SEARCH=$e");
      return placesList;
    }
  }
}
