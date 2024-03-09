import 'package:flutter/material.dart';

import '../../data/models/menus_restaurant/rappi_category.dart';
import '../../data/models/menus_restaurant/rappi_product.dart';
import '../../data/models/menus_restaurant/rappi_tab_category.dart';
import '../../domain/riverpod/menus_bloc/menus_notifier.dart';

const categoryHeight = 55.0;
const productHeight = 130.0;

class MenuRestaurant extends StatefulWidget {
  final String placeId;

  const MenuRestaurant({super.key, required this.placeId});

  @override
  State<MenuRestaurant> createState() => _MenuRestaurantState();
}

class _MenuRestaurantState extends State<MenuRestaurant>
    with SingleTickerProviderStateMixin {
  final _bloc = RappiBloc();
  var isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _bloc.fetchMenu(widget.placeId, this);
      debugPrint('Mahdi: checking: isloading: 2: $isLoading');
      setState(() {
        isLoading = false;
      });
      debugPrint('Mahdi: checking: isloading: 3: $isLoading');
    });
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MenuRestaurant oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.placeId != widget.placeId) {
      _bloc.clearCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: AnimatedBuilder(
                animation: _bloc,
                builder: (_, __) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 70,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Restaurant',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                                icon: const Icon(Icons.arrow_forward),
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
                        labelPadding: EdgeInsets.zero,
                          indicatorPadding: EdgeInsets.zero,
                          onTap:(index){
                          _bloc.onCategorySelected(index);
                          },
                          indicator: const BoxDecoration(),
                          controller: _bloc.tabController,
                          isScrollable: true,
                          overlayColor:
                              const MaterialStatePropertyAll(Colors.transparent ),
                          tabs: _bloc.tabs
                              .map((e) => RappiTabWidget(e))
                              .toList()),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: _bloc.scrollController,
                        itemCount: _bloc.items.length,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemBuilder: (context, index) {
                          final item = _bloc.items[index];
                          if (item.isCategory) {
                            return _RappiCategoryItem(item.category!);
                          } else {
                            return _RappiProductItem(item.product!);
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

class RappiTabWidget extends StatelessWidget {
  const RappiTabWidget(this.tabcategory, {super.key});

  final RappiTabCategory tabcategory;

  @override
  Widget build(BuildContext context) {
    final selected = tabcategory.selected;
    return Opacity(
      opacity: selected ? 1 : 0.5,
      child: SizedBox(
        width: 90,
        height: 45,
        child: Card(
          elevation: tabcategory.selected ? 6 : 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                tabcategory.category.name,
                style: const TextStyle(
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
          style: const TextStyle(
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
                      child: Image.network(
                        product!.image,
                        fit: BoxFit.cover,
                        height: 60,
                        width: 60,
                      )),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${product?.name}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      const SizedBox(
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
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${product!.price.toString()}',
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








