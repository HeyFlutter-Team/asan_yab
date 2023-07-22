import 'package:flutter/material.dart';

import 'databasehelper.dart';
import 'firebase_helper/place.dart';

class FavoriteProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _dataList = [];
  List<Map<String, dynamic>> get dataList => _dataList;

  Future<void> toggleFavorite(String data, Place places) async {
    final forToggle = isExist(data);
    if (forToggle) {
      delete(places.id);
    } else {
      _saveData(places, !forToggle);
    }
    fetchUser();
    notifyListeners();
  }

  bool isExist(String data) {
    for (Map<String, dynamic> i in _dataList) {
      bool toggle = i.values.contains(data);
      if (toggle) {
        return toggle;
      }
      notifyListeners();
    }

    return false;
  }

  void _saveData(Place databaseModel, bool toggle) async {
    await DatabaseHelper.insertUser(databaseModel, toggle);
  }

  void delete(String docId) async {
    await DatabaseHelper.deleteData(docId);
    List<Map<String, dynamic>> updatedData = await DatabaseHelper.getData();

    _dataList = updatedData;

    notifyListeners();
  }

  void fetchUser() async {
    List<Map<String, dynamic>> userList = await DatabaseHelper.getData();
    _dataList = userList;
    notifyListeners();
  }
}
