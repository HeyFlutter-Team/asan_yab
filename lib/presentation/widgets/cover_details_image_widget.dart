import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/res/image_res.dart';
import '../../data/models/place.dart';

class CoverDetailsImagewidget extends StatelessWidget {
  const CoverDetailsImagewidget({
    super.key,
    required this.places,
    required this.size,
  });

  final Place? places;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: places!.coverImage,
          width: double.infinity,
          height: size.height * 0.31,
          fit: BoxFit.cover,
          placeholder: (context, url) => Image.asset(ImageRes.asanYab),
        ),
      ),
    );
  }
}
