import 'package:asan_yab/data/models/menus_restaurant/rappi_product.dart';


class RappiCategory {
  const RappiCategory({
    required this.name,
    required this.product,
  });

  final String name;
  final List<RappiProduct> product;
}
