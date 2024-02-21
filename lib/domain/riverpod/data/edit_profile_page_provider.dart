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

  Future editData(TextEditingController nameController,
      TextEditingController lastNameController) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('User')
            .doc(user.uid)
            .update({
          'name': nameController.text,
          'lastName': lastNameController.text
          // Add other fields you want to update here
        });
        state = EditProfileState(
            name: nameController.text, lastName: lastNameController.text);
        print('Data updated successfully!');
      } else {
        print('User is not authenticated!');
        // Handle case when user is not authenticated
      }
    } catch (error) {
      print('Error updating data: $error');
      // Handle error when updating data fails
    }
  }

  updateName(String newName) {
    state.name = newName;
  }

  updateLastName(String newLastName) {
    state.lastName = newLastName;
  }
}

final editProfilePageProvider =
    StateNotifierProvider<EditProfile, EditProfileState>(
        (ref) => EditProfile());
