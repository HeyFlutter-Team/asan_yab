import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final noteProvider = ChangeNotifierProvider<Note>((ref) => Note());

class Note extends ChangeNotifier {
  String note = '';
  bool isLoading = false;
  Future<void> getNote(WidgetRef ref, bool isRTL) async {
    isLoading = true;
    final snapshot = await FirebaseFirestore.instance
        .collection('Description')
        .doc('add_new_place')
        .get();
    if (snapshot.exists) {
      if (!isRTL) {
        note = snapshot.data()?['eNote'];
      } else {
        note = snapshot.data()?['pNote'];
      }
    }
    isLoading = false;
    notifyListeners();
  }
}
