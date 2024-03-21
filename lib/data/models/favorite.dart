class Favorite {
  final List<String> items;

  const Favorite({required this.items});

  factory Favorite.fromJson(Map<String, dynamic> json) {
    final List<dynamic> jsonItems = json['items'] ?? [];
    final List<String> items =
        jsonItems.map((item) => item.toString()).toList();

    return Favorite(items: items);
  }

  Map<String, dynamic> toJson() => {
        'items': items,
      };
}
