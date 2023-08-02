import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';
import '../constants/kcolors.dart';
import '../database/firebase_helper/place.dart';
import '../pages/detials_page.dart';
import '../providers/categories_items_provider.dart';
import '../utils/convert_digits_to_farsi.dart';
import '.IncrementallyLoadingListView.dart';

class CategoryItem extends StatefulWidget {
  final String id;
  const CategoryItem({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await Provider.of<CategoriesItemsProvider>(context, listen: false)
          .getInitPlaces(widget.id);
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.width;
    return Consumer<CategoriesItemsProvider>(
        builder: (context, placeProvider, __) {
      final places = placeProvider.places;
      return _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blueGrey,
                strokeWidth: 5,
              ),
            )
          : IncrementallyLoadingListView(
              shrinkWrap: true,
              hasMore: () => placeProvider.hasMore,
              itemCount: () => places.length,
              loadMore: () async => await placeProvider.getPlaces(widget.id),
              itemBuilder: (context, index) {
                final phone = places[index].adresses[0].phone;
                final phoneNumber = convertDigitsToFarsi(phone);
                final items = places[index];
                if (index == places.length - 1 &&
                    placeProvider.hasMore &&
                    !placeProvider.isLoading) {
                  return Column(
                    children: [
                      itemPlace(
                        context,
                        places,
                        index,
                        screenHeight,
                        screenWidth,
                        items,
                        phoneNumber,
                      ),
                      const SizedBox(child: CircularProgressIndicator())
                    ],
                  );
                }
                return itemPlace(context, places, index, screenHeight,
                    screenWidth, items, phoneNumber);
              },
            );
    });
  }

  Widget itemPlace(
    BuildContext context,
    List<Place> places,
    int index,
    double screenHeight,
    double screenWidth,
    Place items,
    String phoneNumber,
  ) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailsPage(id: places[index].id),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              height: screenHeight * 0.25,
              width: screenWidth * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: CachedNetworkImage(
                      placeholder: (context, url) =>
                          Image.asset('assets/asan_yab.png'),
                      imageUrl: items.logo,
                      width: double.maxFinite,
                      height: double.maxFinite,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      items.name!,
                      overflow: TextOverflow.fade,
                      maxLines: 2,
                      style:
                          const TextStyle(color: Colors.black, fontSize: 18.0),
                    ),
                    const SizedBox(height: 12.0),
                    phoneNumber.isEmpty
                        ? const SizedBox()
                        : SizedBox(
                            width: 180,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black.withOpacity(0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              onPressed: () async {
                                await FlutterPhoneDirectCaller.callNumber(
                                    phoneNumber);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    phoneNumber,
                                    style: TextStyle(
                                        color: kPrimaryColor, fontSize: 16.0),
                                  ),
                                  const Icon(
                                    Icons.phone_android,
                                    color: Colors.green,
                                    size: 25,
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
