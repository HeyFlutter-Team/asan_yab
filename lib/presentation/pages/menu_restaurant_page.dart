import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../data/models/place.dart';

const categoryHeight = 55.0;
const productHeight = 130.0;

class Menu_Restaurant extends StatefulWidget {
  final  String placeId;
  const Menu_Restaurant({super.key,required this.placeId});

  @override
  State<Menu_Restaurant> createState() => _Menu_RestaurantState();
}

class _Menu_RestaurantState extends State<Menu_Restaurant>
    with SingleTickerProviderStateMixin {
  final _bloc = RappiBloc();

  @override
  void initState() {
    _bloc.init(this);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('Places')
          .doc(widget.placeId)
          .get();
      if (docSnapshot.exists) {
        Place restaurantMenu =
        Place.fromJson(docSnapshot.data() as Map<String, dynamic>);
        final List<String> menuItemNames = restaurantMenu.menuItemName!;
        final List<String> customPopups =
            menus;

        for (final String itemName in menuItemNames) {
          if (!customPopups.contains(itemName)) {
            menus.add(itemName);
          }
        }

        for (int i = 0;
        i < menus.length;
        i++) {
          print('sharif');
          print(menus[i]);
        }
      }
    });
  }
final List<String> menus =[];
  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _bloc,
          builder: (_, __) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 70,
                child: Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Restaurant',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ],
                  ),
                ),
              ),
              Container(
                height: 60,
                child: TabBar(
                  indicatorPadding: EdgeInsets.zero,
                    onTap: _bloc.onCategorySelected,
                    indicator: BoxDecoration(),
                    controller: _bloc.tabController,
                    isScrollable: true,
                     overlayColor:MaterialStatePropertyAll(Colors.transparent),
                    tabs: _bloc.tabs.map((e) => _RappiTabWidget(e)).toList()),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _bloc.scrollController,
                  itemCount: _bloc.items.length,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (context, index) {
                    final item = _bloc.items[index];
                    if (item.isCategory) {
                      return _RappiCategoryItem(item.category);
                    } else {
                      return _RappiProductItem(item.product);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RappiTabWidget extends StatelessWidget {
  const _RappiTabWidget(this.tabcategory);
  final RappiTabCategory tabcategory;

  @override
  Widget build(BuildContext context) {
    final selected = tabcategory.selected;
    return Opacity(
      opacity: selected ? 1 : 0.5,
      child: SizedBox(
        width: 130,
        height: 45,
        child: Card(
          elevation: tabcategory.selected ? 6 : 0,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                tabcategory.category.name,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//
class _RappiCategoryItem extends StatelessWidget {
  const _RappiCategoryItem(this.category);
  final RappiCategory? category;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: categoryHeight,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Text(
          category!.name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _RappiProductItem extends StatelessWidget {
  const _RappiProductItem(this.product);
  final RappiProduct? product;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: productHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Card(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white // Set light theme color
                : Colors.black87,
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            shadowColor: Theme.of(context).brightness == Brightness.light
                ? Colors.black // Set light theme color
                : Colors.grey,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        product!.image,
                        fit: BoxFit.cover,
                        height: 60,
                        width: 60,
                      )),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        product!.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        product!.description,
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black87 // Set light theme color
                                    : Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${product!.price.toString()} AF',
                        style: TextStyle(
                            color: Theme.of(context).brightness ==
                                    Brightness.light
                                ? Colors.pink.shade900 // Set light theme color
                                : Colors.blueGrey.shade600,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
//

//
class RappiBloc with ChangeNotifier {
  late List<RappiTabCategory> tabs = [];
  late List<RappiItem> items = [];
  late TabController tabController;
  ScrollController scrollController = ScrollController();
  bool _listen =true;
  void init(TickerProvider ticker) {
    tabController =
        TabController(length: rappiCategories.length, vsync: ticker);

    double offsetFrom = 0.0;
    double ofssetTo = 0.0;

    for (int i = 0; i < rappiCategories.length; i++) {
      final category = rappiCategories[i];

      if (i > 0) {
        offsetFrom += rappiCategories[i - 1].product.length * productHeight;
      }
      if (i < rappiCategories.length - 1) {
        ofssetTo =
            offsetFrom + rappiCategories[i + 1].product.length * productHeight;
      } else {
        ofssetTo = double.infinity;
      }
      tabs.add(
        RappiTabCategory(
          category: category,
          selected: (i == 0),
          offsetFrom: categoryHeight * i + offsetFrom,
          offsetTo: ofssetTo,
        ),
      );

      items.add(
        RappiItem(category: category),
      );
      for (int j = 0; j < category.product.length; j++) {
        final product = category.product[j];
        items.add(
          RappiItem(product: product),
        );
      }
    }
    scrollController.addListener(_onScrollListener);
  }

  void _onScrollListener() {
    if(_listen){
    for (int i = 0; i < tabs.length; i++) {
      final tab = tabs[i];
      if (scrollController.offset >= tab.offsetFrom &&
          scrollController.offset <= tab.offsetTo &&
          !tab.selected) {
        onCategorySelected(i, animationRequired: false);
        tabController.animateTo(i);
        break;
      }
    }
    }
  }

  void onCategorySelected(int index, {bool animationRequired = true})async{
    final selected = tabs[index];
    for (int i = 0; i < tabs.length; i++) {
      final condition = selected.category.name == tabs[i].category.name;
      tabs[i] = tabs[i].copyWith(condition);
    }
    notifyListeners();
    if (animationRequired) {
      _listen=false;
     await scrollController.animateTo(selected.offsetFrom,
          duration: Duration(milliseconds: 500), curve: Curves.bounceIn);
     _listen=true;
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScrollListener);
    scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }
}
//

//
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
//

//
class RappiItem {
  RappiItem({this.category, this.product});
  final RappiCategory? category;
  final RappiProduct? product;
  bool get isCategory => category != null;
}
//

//
class RappiCategory {
  const RappiCategory({
    required this.name,
    required this.product,
  });
  final String name;
  final List<RappiProduct> product;
}

class RappiProduct {
  const RappiProduct({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });
  final String name;
  final String description;
  final double price;
  final String image;
}

const rappiCategories = [
  RappiCategory(name: 'Orden again', product: [
    RappiProduct(
        name: 'Silim Lights',
        description: 'Beef-Bibimbap mit Rise, Bohnen, Spinat,',
        price: 220,
        image: 'assets/image 10.png'),
    RappiProduct(
        name: 'double burger',
        description: 'Beef-Bibimbap mit Rise, Bohnen, Spinat,',
        price: 220,
        image: 'assets/image 10.png'),
    RappiProduct(
        name: 'Pizza',
        description: 'Beef-Bibimbap mit Rise, Bohnen, Spinat,',
        price: 620,
        image: 'assets/image 10.png'),
    RappiProduct(
        name: 'hojjat',
        description: 'Beef-Bibimbap mit Rise, Bohnen, Spinat,',
        price: 890,
        image: 'assets/image 10.png'),
  ]),
  RappiCategory(name: 'Picker', product: [
    RappiProduct(
        name: 'Sudogwon',
        description: 'Beef-Bibimbap mit Rise, Bohnen, Spinat,',
        price: 330,
        image: 'assets/image 10.png'),
    RappiProduct(
        name: 'Met',
        description: 'Beef-Bibimbap mit Rise, Bohnen, Spinat,',
        price: 420,
        image: 'assets/image 10.png'),
    RappiProduct(
        name: 'Burger',
        description: 'Beef-Bibimbap mit Rise, Bohnen, Spinat,',
        price: 280,
        image: 'assets/image 10.png'),
  ]),
  RappiCategory(name: 'startes', product: [
    RappiProduct(
        name: 'Sudogwon',
        description: 'Beef-Bibimbap mit Rise, Bohnen, Spinat,',
        price: 330,
        image: 'assets/image 10.png'),
    RappiProduct(
        name: 'Met',
        description: 'Beef-Bibimbap mit Rise, Bohnen, Spinat,',
        price: 420,
        image: 'assets/image 10.png'),
    RappiProduct(
        name: 'Burger',
        description: 'Beef-Bibimbap mit Rise, Bohnen, Spinat,',
        price: 280,
        image: 'assets/image 10.png'),
  ]),
  RappiCategory(name: 'Picker for you', product: [
    RappiProduct(
        name: 'Sudogwon',
        description: 'Beef-Bibimbap mit Rise, Bohnen, Spinat,',
        price: 330,
        image: 'assets/image 10.png'),
    RappiProduct(
        name: 'Met',
        description: 'Beef-Bibimbap mit Rise, Bohnen, Spinat,',
        price: 420,
        image: 'assets/image 10.png'),
    RappiProduct(
        name: 'Burger',
        description: 'Beef-Bibimbap mit Rise, Bohnen, Spinat,',
        price: 280,
        image: 'assets/image 10.png'),
  ]),
];
//
class Item {
  final String fName;
  final String fDescription;
  final String fPrice;
  final String fImage;

  Item(
      {required this.fName,
        required this.fDescription,
        required this.fPrice,
        required this.fImage});

  Map<String, dynamic> toJson() {
    return {
      'foodName': fName,
      'foodDescription': fDescription,
      'foodPrice': fPrice,
      "foodImageUrl": fImage
    };
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        fName: json['foodName'],
        fDescription: json['foodDescription'],
        fPrice: json['foodPrice'],
        fImage: json['foodImageUrl']);
  }
}

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