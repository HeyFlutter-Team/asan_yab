import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/models/menus_restaurant/rapp_iItem.dart';
import '../../../data/models/menus_restaurant/rappi_category.dart';
import '../../../data/models/menus_restaurant/rappi_product.dart';
import '../../../data/models/menus_restaurant/rappi_tab_category.dart';
import '../../../data/models/menus_restaurant/restaurant_menu.dart';
import '../../../data/models/place.dart';
import '../../../presentation/pages/menu_restaurant_page.dart';

class RappiBloc with ChangeNotifier {
  late List<RappiTabCategory> tabs = [];
  late List<RappiItem> items = [];
  List<RappiCategory> rappiCategories = [];

  TabController? tabController;
  ScrollController scrollController = ScrollController();
  bool _listen = true;

  Future<void> fetchMenu(String placeId, TickerProvider ticker) async {
    rappiCategories.clear(); // Clear previous categories
    items.clear();
    tabs.clear();

    final List<String> menus = [];

    // Fetch menu data
    DocumentSnapshot docSnapshot =
    await FirebaseFirestore.instance.collection('Places').doc(placeId).get();
    if (docSnapshot.exists) {
      Place restaurantMenu =
      Place.fromJson(docSnapshot.data() as Map<String, dynamic>);
      final List<String> menuItemNames = restaurantMenu.menuItemName!;
      final List<String> customPopups = menus;

      for (final String itemName in menuItemNames) {
        if (!customPopups.contains(itemName)) {
          menus.add(itemName);
        }
      }

      final menus2 = await FirebaseFirestore.instance
          .collection('Places')
          .doc(placeId)
          .collection('menus')
          .get();

      tabController = TabController(length: menus2.docs.length, vsync: ticker);

      for (int i = 0; i < menus2.docs.length; i++) {
        List<RappiProduct> rappiProduct = [];

        final docSnapshot = menus2.docs.firstWhere((doc) {
          debugPrint('Mahdi: checking: 2: ${doc.id} : ${menus[i]}');

          return doc.id == menus[i];
        });

        if (docSnapshot.exists) {
          final restaurantMenu = RestaurantMenu.fromJson(docSnapshot.data());

          debugPrint('Mahdi: checking: 3: ${docSnapshot} : ${restaurantMenu}');

          for (int j = 0; j < restaurantMenu.menus.length; j++) {
            rappiProduct.add(RappiProduct(
                name: restaurantMenu.menus[j].fName,
                description: restaurantMenu.menus[j].fDescription,
                price: restaurantMenu.menus[j].fPrice,
                image: restaurantMenu.menus[j].fImage));
          }
          print('sharif${menus}');
        }

        rappiCategories
            .add(RappiCategory(name: menus[i], product: rappiProduct));
      }

      double offsetFrom = 0.0;
      double ofssetTo = 0.0;

      for (int i = 0; i < rappiCategories.length; i++) {
        final category = rappiCategories[i];

        if (i > 0) {
          offsetFrom += rappiCategories[i - 1].product.length * productHeight;
        }
        if (i < rappiCategories.length - 1) {
          ofssetTo = offsetFrom +
              rappiCategories[i + 1].product.length * productHeight;
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

        items.add(RappiItem(category: category));
        for (int j = 0; j < category.product.length; j++) {
          final product = category.product[j];
          items.add(RappiItem(product: product));
        }
      }

      tabController!.addListener(() {
        if (tabController!.indexIsChanging) {
          _listen = false;
          scrollController.animateTo(
            tabs[tabController!.index].offsetFrom,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
          _listen = true;
        }
      });

      scrollController.addListener(_onScrollListener);

      notifyListeners();
    }
  }

  void _onScrollListener() {
    if (_listen) {
      for (int i = 0; i < tabs.length; i++) {
        final tab = tabs[i];
        if (scrollController.offset >= tab.offsetFrom &&
            scrollController.offset <= tab.offsetTo &&
            !tab.selected) {
          onCategorySelected(i, animationRequired: false);
          break;
        }
      }
    }
  }

  void onCategorySelected(int index, {bool animationRequired = true}) async {
    final selected = tabs[index];
    for (int i = 0; i < tabs.length; i++) {
      final condition = selected.category.name == tabs[i].category.name;
      tabs[i] = tabs[i].copyWith(condition);
    }
    notifyListeners();
    if (animationRequired) {
      _listen = false;
      await scrollController.animateTo(selected.offsetFrom,
          duration: Duration(milliseconds: 500), curve: Curves.bounceIn);
      _listen = true;
    }
  }

  void clearCategories() {
    rappiCategories.clear();
    tabs.clear();
    items.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScrollListener);
    scrollController.dispose();
    tabController!.dispose();
    super.dispose();
  }
}
