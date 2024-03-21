import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfileState {
  String name = '';
  String lastName = '';

  EditProfileState({
    required this.name,
    required this.lastName,
  });
}

class EditProfile extends StateNotifier<EditProfileState> {
  EditProfile() : super(EditProfileState(name: '', lastName: ''));

  Future editData(
    TextEditingController nameController,
    TextEditingController lastNameController,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('User')
            .doc(user.uid)
            .update({
          'name': nameController.text,
          'lastName': lastNameController.text
        });
        state = EditProfileState(
            name: nameController.text, lastName: lastNameController.text);
        debugPrint('Data updated successfully!');
      } else {
        debugPrint('User is not authenticated!');
      }
    } catch (error) {
      debugPrint('Error updating data: $error');
    }
  }

  updateName(String newName) => state.name = newName;

  updateLastName(String newLastName) => state.lastName = newLastName;
}

final editProfilePageProvider =
    StateNotifierProvider<EditProfile, EditProfileState>(
        (ref) => EditProfile());
