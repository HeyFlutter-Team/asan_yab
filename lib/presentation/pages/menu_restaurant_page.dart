import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/menus_restaurant/rappi_category.dart';
import '../../data/models/menus_restaurant/rappi_product.dart';
import '../../data/models/menus_restaurant/rappi_tab_category.dart';
import '../../domain/riverpod/data/single_place_provider.dart';
import '../../domain/riverpod/menus_bloc/menus_notifier.dart';

const categoryHeight = 55.0;
const productHeight = 130.0;

class MenuRestaurant extends ConsumerStatefulWidget {
  final String placeId;

  const MenuRestaurant({super.key, required this.placeId});

  @override
  ConsumerState<MenuRestaurant> createState() => _MenuRestaurantState();
}

class _MenuRestaurantState extends ConsumerState<MenuRestaurant>
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
    final places = ref.watch(getSingleProvider);
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title:Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            '${places?.name}',
            style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
      ),
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
                    SizedBox(
                      height: 60,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TabBar(
                            tabAlignment: TabAlignment.start,
                            labelPadding: const EdgeInsets.only(left: 7,right: 7),
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
                    ),
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
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
        height: 45,
        child: Card(
          elevation: tabcategory.selected ? 6 : 1,
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
        padding: const EdgeInsets.all(10.0),
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
                    child: CachedNetworkImage(
                      errorWidget: (context, url, error) => Image.asset('assets/asan_yab.jpg'),
                      imageUrl: product!.image,
                      placeholder: (context, url) => Image.asset('assets/asan_yab.jpg'),
                      fit: BoxFit.cover,
                      height: 70,
                      width: 70,
                    ),
                  ),
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








