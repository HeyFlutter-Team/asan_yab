import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../data/models/place.dart';
import 'page_view_item_widget.dart';

class DetailsGalleryWidget extends StatelessWidget {
  const DetailsGalleryWidget({
    super.key,
    required this.size,
    required this.places,
  });

  final Size size;
  final Place? places;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.25.h,
      child: places!.gallery.isEmpty
          ? LoadingAnimationWidget.fourRotatingDots(
              color: Colors.redAccent, size: 60)
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: places!.gallery.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(
                    top: 6, left: 2, right: 2, bottom: 18),
                child: PageViewItemWidget(
                  selectedIndex: index,
                  gallery: places!.gallery,
                ),
              ),
            ),
    );
  }
}
