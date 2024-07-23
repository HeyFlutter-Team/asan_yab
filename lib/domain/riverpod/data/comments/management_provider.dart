import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final managementProvider =
    ChangeNotifierProvider<ManagementPr>((ref) => ManagementPr());

class ManagementPr extends ChangeNotifier {
  List<String> _lName = [];
  List<String> _lImage = [];
  late List ownerList = [];
  bool loading = false;
  bool debounceInProgress = false; // Flag to track debounce status

  // Getter for lname
  List<String> get lname => _lName;

  // Setter for lname
  set lname(List<String> value) {
    _lName = value;
    notifyListeners();
  }

  // Getter for lImage
  List<String> get lImage => _lImage;

  // Setter for lImage
  set lImage(List<String> value) {
    _lImage = value;
    notifyListeners();
  }

  Future<void> getInfo() async {
    // Check if debounce is in progress, if so, return immediately
    if (debounceInProgress) return;

    loading = true;
    debounceInProgress = true; // Set debounce flag
    notifyListeners();

    print("hello ali hadid");
    _lName = [];
    _lImage = [];

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection("User")
          .doc(currentUser.uid)
          .get();
      ownerList = userDoc.data()?['owner'] as List<dynamic>? ?? [];

      for (int i = 0; i < ownerList.length; i++) {
        final placeDoc = await FirebaseFirestore.instance
            .collection("Places")
            .doc(ownerList[i])
            .get();
        if (placeDoc.exists) {
          final data = placeDoc.data();
          if (data != null) {
            final name = data['name'] as String?;
            final image = data['logo'] as String?;
            _lName.add(name!);
            _lImage.add(image!);
          }
        } else {
          print('Document for place with ID ${ownerList[i]} does not exist.');
        }
      }
    } else {
      print('Current user is null.');
    }

    loading = false;
    debounceInProgress = false; // Reset debounce flag
    notifyListeners();
  }
}
