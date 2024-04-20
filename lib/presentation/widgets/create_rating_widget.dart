// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CreateRatingWidget extends StatelessWidget {
  double rate;
  CreateRatingWidget({super.key, required this.rate});

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: rate,
      itemSize: 35,
      minRating: 1,
      maxRating: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4),
      updateOnDrag: true,
      itemBuilder: (context, _) => const Icon(
        Icons.star_rate,
        color: Colors.amber,
      ),
      onRatingUpdate: (value) {
        rate = value;
      },
    );
  }
}
