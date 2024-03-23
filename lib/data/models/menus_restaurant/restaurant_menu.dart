import 'item.dart';

class RestaurantMenu {
  // final String? type;
  final List<Item> menus;

  RestaurantMenu({
    // this.type,
    required this.menus,
  });

  factory RestaurantMenu.fromJson(Map<String, dynamic> json) {
    return RestaurantMenu(
      // type: json['type'],
      menus: json['menus'] != null
          ? List<Item>.from(json['menus'].map((menu) => Item.fromJson(menu)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'type': type,
      'menus': menus.map((menu) => menu.toJson()).toList(),
    };
  }
}
