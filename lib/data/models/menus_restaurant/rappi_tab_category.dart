import 'package:asan_yab/data/models/menus_restaurant/rappi_category.dart';

class RappiTabCategory {
  const RappiTabCategory(
      {required this.category,
        required this.selected,
        required this.offsetFrom,
        required this.offsetTo});

  RappiTabCategory copyWith(bool selected) => RappiTabCategory(
      category: category,
      selected: selected,
      offsetFrom: offsetFrom,
      offsetTo: offsetTo);
  final RappiCategory category;
  final bool selected;
  final double offsetFrom;
  final double offsetTo;
}