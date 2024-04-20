import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/riverpod/data/profile_data.dart';
import 'translation_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomProgressIndicatorWidget {
  static progressIndicator({required WidgetRef ref}) =>
      StreamBuilder<TaskSnapshot>(
        stream: ref.watch(imageNotifierProvider).uploadTask?.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            final progress = data.bytesTransferred / data.totalBytes;
            if (data.state == TaskState.success) {
              ref.watch(profileDataProvider.notifier).getCurrentUserData();
              return Container();
            }
            return SizedBox(
              height: 50.h,
              width: 50.w,
              child: CircularProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey,
                color: Colors.red,
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      );

  static void showBottomSheets({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    final text = texts(context);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                onTap: () {
                  // Handle Camera option
                  ref
                      .read(imageNotifierProvider.notifier)
                      .pickImage(ImageSource.camera);
                  context.pop();
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(Icons.camera),
                    SizedBox(height: 8.0.h),
                    Text(text.profile_buttonSheet_camera),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  ref
                      .read(imageNotifierProvider.notifier)
                      .pickImage(ImageSource.gallery);
                  context.pop();
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.image),
                    SizedBox(height: 8.0.h),
                    Text(text.profile_buttonSheet_gallery),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
