import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/firebase_collection_names.dart';
import '../../../data/models/users.dart';

final profileDetailsProvider =
    StateNotifierProvider<ProfileDataProvider, Users?>(
  (ref) => ProfileDataProvider(),
);

class ProfileDataProvider extends StateNotifier<Users?> {
  ProfileDataProvider({Users? user}) : super(user);

  Future<void> getCurrentUserData() async {
    final firebaseAuth = FirebaseAuth.instance.currentUser;
    final firestore = FirebaseFirestore.instance;
    try {
      if (firebaseAuth != null) {
        final userSnapshot = await firestore
            .collection(FirebaseCollectionNames.user)
            .doc(firebaseAuth.uid)
            .get();

        if (userSnapshot.exists) {
          state = Users.fromMap(userSnapshot.data()!);
        } else {
          debugPrint('User data not found for user ID: ${firebaseAuth.uid}');
        }
      } else {
        debugPrint('Current user is null');
      }
    } catch (e, stackTrace) {
      debugPrint('Error getting current user data: $e\n$stackTrace');
    }
  }

  void disposeUserData() => state = null;

  void copyToClipboard(String text) => FlutterClipboard.copy(text);
}

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

class ImageNotifier extends StateNotifier<ImageState> {
  ImageNotifier() : super(ImageState());
  final _imagePicker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedImage = await _imagePicker.pickImage(source: source);
      if (pickedImage == null) return;

      final imageTemp = File(pickedImage.path);
      state = state.copyWith(image: imageTemp, imageUrl: pickedImage.path);
      uploadFile();
    } catch (e, stackTrace) {
      debugPrint('Failed to pick image: $e\n$stackTrace');
    }
  }

  Future<void> uploadFile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (state.image == null || user == null) return;

    final imageFileName = state.image!.path.split('/').last;
    final path = 'files/${user.uid}/$imageFileName';
    final ref = FirebaseStorage.instance.ref().child(path);

    try {
      final uploadTask = ref.putFile(state.image!);
      state = state.copyWith(uploadTask: uploadTask);

      final snapshot = await uploadTask.whenComplete(() {});
      final uploadedImageUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.user)
          .doc(user.uid)
          .update({'imageUrl': uploadedImageUrl});

      state = state.copyWith(imageUrl: uploadedImageUrl);
    } catch (e, stackTrace) {
      debugPrint('Error uploading image: $e\n$stackTrace');
    }
  }
}

final imageProvider = StateNotifierProvider<ImageNotifier, ImageState>(
  (ref) => ImageNotifier(),
);
