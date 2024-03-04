import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/users.dart';

final userDetailsProvider = StateNotifierProvider<ReadUserDetails, Users?>(
  (ref) => ReadUserDetails(),
);

class ReadUserDetails extends StateNotifier<Users?> {
  ReadUserDetails({Users? user}) : super(user);

  Future<void> getCurrentUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userSnapshot = await FirebaseFirestore.instance
            .collection('User')
            .doc(user.uid)
            .get();

        if (userSnapshot.exists) {
          state = Users.fromMap(userSnapshot.data()!);
        } else {
          print('User data not found for user ID: ${user.uid}');
        }
      } else {
        print('Current user is null');
      }
    } catch (e, stackTrace) {
      print('Error getting current user data: $e\n$stackTrace');
    }
  }

  void disposeUserData() {
    state = null;
  }

  void copyToClipboard(String text) {
    FlutterClipboard.copy(text);
  }
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
  final ImagePicker _imagePicker = ImagePicker();

  // Future<void> pickImage(ImageSource source) async {
  //   try {
  //     final pickedImage = await _imagePicker.pickImage(source: source);
  //     if (pickedImage == null) return;
  //
  //     final imageTemp = File(pickedImage.path);
  //     state = state.copyWith(image: imageTemp, imageUrl: pickedImage.path);
  //     uploadFile();
  //   } catch (e, stackTrace) {
  //     print('Failed to pick image: $e\n$stackTrace');
  //   }
  // }

  Future<void> pickImage(ImageSource source) async {
    try {
      await _imagePicker.pickImage(source: source).then((image)async {
        if (image == null) {
          return;
        }
        await ImageCropper().cropImage(sourcePath: image.path,
            cropStyle: CropStyle.circle,
            aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1))
            .then((croppedImage){
          if (croppedImage == null) {
            return;
          }
          final imageTemp = File(croppedImage.path);
          state = state.copyWith(image: imageTemp, imageUrl: croppedImage.path);
          uploadFile();
        } );
      });



    } catch (e, stackTrace) {
      print('Failed to pick image: $e\n$stackTrace');
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

      await FirebaseFirestore.instance.collection('User').doc(user.uid).update({
        'imageUrl': uploadedImageUrl,
      });

      state = state.copyWith(imageUrl: uploadedImageUrl);
    } catch (e, stackTrace) {
      print('Error uploading image: $e\n$stackTrace');
    }
  }
  // Future<void> deleteImageAndClearUrl(String imageUrl) async {
  //   try {
  //     // Delete the image file from storage
  //     final imageRef = FirebaseStorage.instance.refFromURL(imageUrl);
  //     await imageRef.delete();
  //     print('younis: Image deleted successfully.');
  //
  //     // Clear the image URL from the user's profile in the database
  //     final user = FirebaseAuth.instance.currentUser;
  //     if (user != null) {
  //       await FirebaseFirestore.instance.collection('User').doc(user.uid).update({
  //         'imageUrl': '',
  //       });
  //       print('Image URL cleared from database.');
  //     }
  //   } catch (error) {
  //     print('Error deleting image: $error');
  //   }
  // }


}

final imageProvider = StateNotifierProvider<ImageNotifier, ImageState>(
  (ref) => ImageNotifier(),
);


class DeleteProfile extends ChangeNotifier{

  Future<void> deleteImageAndClearUrl(String imageUrl) async {
    try {
      // Delete the image file from storage
      final imageRef = FirebaseStorage.instance.refFromURL(imageUrl);
      await imageRef.delete();
      print('younis: Image deleted successfully.');
notifyListeners();
      // Clear the image URL from the user's profile in the database
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('User').doc(user.uid).update({
          'imageUrl': '',
        });
        notifyListeners();
        print('Image URL cleared from database.');
      }
      notifyListeners();

    } catch (error) {
      print('Error deleting image: $error');
    }
  }
}

final deleteProfile=ChangeNotifierProvider<DeleteProfile>((ref) => DeleteProfile());