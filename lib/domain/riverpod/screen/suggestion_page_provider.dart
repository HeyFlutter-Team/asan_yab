import 'package:asan_yab/data/models/language.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositoris/language_repository.dart';

final noteProvider = ChangeNotifierProvider<Note>((ref) => Note());

class Note extends ChangeNotifier {
  String note = '';
  final bool _isLoading = true;
  bool get isLoading => _isLoading;

  // Future<void> getNote(WidgetRef ref) async {
  //   final snapshot = await FirebaseFirestore.instance
  //       .collection('Description')
  //       .doc('add_new_place')
  //       .get();
  //
  //   if (snapshot.exists) {
  //     final isRTL = ref.watch(languageProvider).code == 'fa';
  //     if (!isRTL) {
  //       note = snapshot.data()?['eNote'];
  //     } else {
  //       note = snapshot.data()?['pNote'];
  //     }
  //   }
  //
  //   notifyListeners();
  // }
}
