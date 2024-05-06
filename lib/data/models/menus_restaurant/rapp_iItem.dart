import 'package:asan_yab/data/models/menus_restaurant/rappi_category.dart';
import 'package:asan_yab/data/models/menus_restaurant/rappi_product.dart';


class RappiItem {
  RappiItem({this.category, this.product});

  final RappiCategory? category;
  final RappiProduct? product;

  bool get isCategory => category != null;

  RappiItem copyWith({RappiCategory? category, RappiProduct? product}) {
    return RappiItem(
      category: category ?? this.category,
      product: product ?? this.product,
    );
  }
}
