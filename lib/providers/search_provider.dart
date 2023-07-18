// ignore_for_file: unused_field, prefer_final_fields

import 'package:flutter/material.dart';

import '../model/favorite.dart';

class SearchProvider with ChangeNotifier{
  // all about the lazy Loading 

  List<Favorite> _loading =[
    Favorite(
      image:"",
      name:"Sharif",
      phone:"0789097550",
      id:1
      ),
      Favorite(
      image:"",
      name:"Ali",
      phone:"078909734",
      id:2
      ),
      Favorite(
      image:"",
      name:"Aziz",
      phone:"0790236824",
      id:3
      ),
      Favorite(
      image:"",
      name:"Karem",
      phone:"0798458798",
      id:4
      ),
       Favorite(
      image:"",
      name:"Karem",
      phone:"0798458798",
      id:4
      ),
       Favorite(
      image:"",
      name:"Karem",
      phone:"0798458798",
      id:4
      ),
       Favorite(
      image:"",
      name:"Karem",
      phone:"0798458798",
      id:4
      ),
       Favorite(
      image:"",
      name:"Karem",
      phone:"0798458798",
      id:4
      ),
       Favorite(
      image:"",
      name:"Karem",
      phone:"0798458798",
      id:4
      ),
       Favorite(
      image:"",
      name:"Karem",
      phone:"0798458798",
      id:4
      ),
    

  ];
  List<Favorite> _searchResult =[];
  List<Favorite> get lazyLoading=>_searchResult; 
  bool _isLoading = false;
  int _pageNumber =0;
  bool get isloading => _isLoading;
  Future<void> fetchLazyLoading() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds:2));
    _loading.addAll([
      Favorite(
        image: '',
        name: 'John Doe',
        phone: '+123456789',
        id: 5,
      ),
      Favorite(
        image: '',
        name: 'Jane Smith',
        phone: '+987654321',
        id: 6,
      ),
      Favorite(
        image: '',
        name: 'Bob Johnson',
        phone: '+555555555',
        id: 7,
      ),
      Favorite(
        image: '',
        name: 'Jane  Johnson',
        phone: '+555555555',
        id: 8,
      ),
      Favorite(
        image: '',
        name: 'Bob Johnson',
        phone: '+555555555',
        id: 9,
      ),
      Favorite(
        image: '',
        name: 'Smith Johnson',
        phone: '+555555555',
        id: 10,
      ),
      Favorite(
        image: '',
        name: 'Smith Johnson',
        phone: '+555555555',
        id: 11,
      ),
      Favorite(
        image: '',
        name: 'Bob Johnson',
        phone: '+555555555',
        id: 12,
      ),

    ]);
    _pageNumber++;
    _isLoading = false;
    notifyListeners();
  }

   void searchItems(String query) {
   _searchResult = _loading
        .where((item) =>
            item.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
        notifyListeners();    
  }

}