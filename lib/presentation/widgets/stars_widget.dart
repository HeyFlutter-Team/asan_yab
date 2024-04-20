import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/riverpod/data/firebase_rating_provider.dart';

class StarsWidget extends ConsumerWidget {
  const StarsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final averageRatingProvider =
        ref.watch(firebaseRatingProvider).averageRatingProvider;
    return Row(
      children: [
        Icon(
          Icons.star,
          color: averageRatingProvider <= 0 ? Colors.grey : Colors.amber,
        ),
        Icon(
          Icons.star,
          color: averageRatingProvider <= 1 ? Colors.grey : Colors.amber,
        ),
        Icon(
          Icons.star,
          color: averageRatingProvider <= 2 ? Colors.grey : Colors.amber,
        ),
        Icon(
          Icons.star,
          color: averageRatingProvider <= 3 ? Colors.grey : Colors.amber,
        ),
        Icon(
          Icons.star,
          color: averageRatingProvider <= 4 ? Colors.grey : Colors.amber,
        ),
      ],
    );
  }
}
