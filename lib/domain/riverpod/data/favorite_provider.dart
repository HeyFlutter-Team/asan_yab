import 'dart:typed_data';

import 'package:asan_yab/domain/riverpod/data/toggle_favorite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositoris/local_rep/databasehelper.dart';
import '../../../data/models/place.dart';

final favoriteProvider =
    StateNotifierProvider<FavoriteProvider, List<Map<String, dynamic>>>(
        (ref) => FavoriteProvider([], ref));

class FavoriteProvider extends StateNotifier<List<Map<String, dynamic>>> {
  final Ref ref;
  FavoriteProvider(super.state, this.ref);

  Future<void> toggleFavorite(
      String data,
      Place places,
      List<String> addressDataList,
      List<String> phoneDataList,
      Int8List logo,
      Int8List coverImage) async {
    final forToggle = isExist(data);
    if (forToggle) {
      delete(places.id);
      ref.read(toggleProvider.notifier).toggle(false);
    } else {
      _saveData(
          places, addressDataList, phoneDataList, !forToggle, logo, coverImage);
      ref.read(toggleProvider.notifier).toggle(true);
    }
    fetchUser();
  }

  bool isExist(String data) {
    for (Map<String, dynamic> i in state) {
      bool toggle = i.values.contains(data);
      if (toggle) {
        return toggle;
      }
    }

    return false;
  }

  void _saveData(
      Place databaseModel,
      List<String> addressDataList,
      List<String> phoneDataList,
      bool toggle,
      Int8List logo,
      Int8List coverImage) async {
    await DatabaseHelper.insertUser(databaseModel, addressDataList,
        phoneDataList, toggle, logo, coverImage);
  }

  void delete(String docId) async {
    await DatabaseHelper.deleteData(docId);
    List<Map<String, dynamic>> updatedData = await DatabaseHelper.getData();

    state = updatedData;
  }

  void fetchUser() async {
    List<Map<String, dynamic>> userList = await DatabaseHelper.getData();
    state = userList;
  }
}
