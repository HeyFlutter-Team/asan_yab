import 'package:flutter/material.dart';

import 'databasehelper.dart';
import 'firebase_helper/place.dart';

class FavoriteProvider extends ChangeNotifier {
  List<Map<String,dynamic>> _dataList = [];
  List<Map<String,dynamic>> get dataList => _dataList;
  bool _toggle = false ;
  bool get toggle => _toggle;


  Future<void> toggleFavorite(bool data,Place places) async {

    if (data) {
      _toggle = !_toggle;
     _delete(places.id) ;

    } else {
      _toggle = !_toggle;
      _saveData(places,_toggle);

    }
    fetchUser();
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

  void _saveData(Place databaseModel,bool toggle) async {
    await DatabaseHelper.insertUser(databaseModel,toggle);
  }
  void _delete(String docId) async {
    await DatabaseHelper.deleteData(docId);
    List<Map<String, dynamic>> updatedData = await DatabaseHelper.getData();
    // setState(() {
    //   dataList = updatedData;
    // });
  }
  void fetchUser() async {
    List<Map<String, dynamic>> userList = await DatabaseHelper.getData();
      _dataList = userList;
      notifyListeners();

  }
}


