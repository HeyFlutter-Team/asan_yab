

// ignore_for_file: avoid_print

import 'dart:io';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/users.dart';

class UserDetails extends StateNotifier<Users?>{
  UserDetails(super.state);
  Future<Users?> getCurrentUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userSnapshot =
        await FirebaseFirestore
            .instance
            .collection('User')
            .doc(user.uid)
            .get();
        if (userSnapshot.exists) {
       state = Users.fromMap(userSnapshot.data()!);
        return state;

        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print('Younis Error fetching current user data: $e');
      print('younis: state $state');
      return null;
    }
  }
  copyToClipboard(String text) {
    FlutterClipboard.copy(text);
  }
}

final userDetailsProvider=StateNotifierProvider<UserDetails,Users?>((ref) => UserDetails(null));


class ImageState {
  File? image;
  UploadTask? uploadTask;
  String? imageUrl;

  ImageState({
    this.image,
    this.uploadTask,
    this.imageUrl,
  });

  ImageState copyWith({
    File? image,
    UploadTask? uploadTask,
    String? imageUrl,
  }) {
    return ImageState(
      image: image ?? this.image,
      uploadTask: uploadTask ?? this.uploadTask,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

class ImageNotifier  extends StateNotifier<ImageState>{
  ImageNotifier() : super(ImageState());

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedImage = await _imagePicker.pickImage(source: source);
      if (pickedImage == null) return;

      final imageTemp = File(pickedImage.path);
      state = state.copyWith(image: imageTemp);
      uploadFile();
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<void> uploadFile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (state.image == null || user == null) return;

    final imageFileName = state.image!.path.split('/').last;
    final path = 'files/${user.uid}/$imageFileName';
    final ref = FirebaseStorage.instance.ref().child(path);

    try {
      state = state.copyWith(uploadTask: ref.putFile(state.image!));

      final snapshot = await state.uploadTask!.whenComplete(() {});
      final uploadedImageUrl = await snapshot.ref.getDownloadURL();

      FirebaseFirestore.instance.collection('User').doc(user.uid).update({
        'imageUrl': uploadedImageUrl,
      });

      state = state.copyWith(imageUrl: uploadedImageUrl);
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
}

final imageProvider = StateNotifierProvider<ImageNotifier, ImageState>((ref) {
  return ImageNotifier();
});
