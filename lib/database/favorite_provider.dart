import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'databasehelper.dart';
import 'firebase_helper/place.dart';

class FavoriteProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _dataList = [];
  List<Map<String, dynamic>> get dataList => _dataList;

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
    } else {
      _saveData(
          places, addressDataList, phoneDataList, !forToggle, logo, coverImage);
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

    _dataList = updatedData;

    notifyListeners();
  }

  void fetchUser() async {
    List<Map<String, dynamic>> userList = await DatabaseHelper.getData();
    _dataList = userList;
    notifyListeners();
  }
}
