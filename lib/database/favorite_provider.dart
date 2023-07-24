import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  List<String> _dataList = [];
  List<String> get dataList => _dataList;

  Future<void> toggleFavorite(String data) async {
    final isExist = _dataList.contains(data);
    if (isExist) {
      _dataList.remove(data);
    } else {
      _dataList.add(data);
    }
    notifyListeners();
  }

  bool isExist(String data) {
    final isExist = _dataList.contains(data);
    return isExist;
  }

  void clearFavorite() {
    _dataList = [];
    notifyListeners();
  }
}
