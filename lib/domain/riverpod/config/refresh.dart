import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/categories_provider.dart';
import '../data/places_provider.dart';

final refreshNewPlacesProvider = FutureProvider((ref) async {
  return await ref.refresh(placeProvider.notifier).getPlaces();
});
final refreshCategoriesProvider = FutureProvider((ref) async {
  return await ref.read(categoriesProvider.notifier).getCategories();
});
