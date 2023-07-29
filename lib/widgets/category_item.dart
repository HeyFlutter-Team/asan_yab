import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
              child: CircularProgressIndicator(color: Colors.blue),
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

  Padding itemPlace(
      BuildContext context,
      List<Place> places,
      int index,
      double screenHeight,
      double screenWidth,
      Place items,
      String phoneNumber) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 15.0),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsPage(id: places[index].id),
                ),
              );
            },
            child: Container(
              height: screenHeight * 0.3,
              width: screenWidth * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider('${items.logo}'),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 10.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  items.name!,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  style: const TextStyle(color: Colors.black, fontSize: 16.0),
                ),
                const SizedBox(height: 12.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: () async {
                    await FlutterPhoneDirectCaller.callNumber(phoneNumber);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        phoneNumber,
                        style: TextStyle(color: kPrimaryColor, fontSize: 20.0),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.phone_android,
                        color: Colors.green,
                        size: 25,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
