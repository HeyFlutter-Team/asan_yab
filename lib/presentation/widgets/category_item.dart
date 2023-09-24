import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/res/image_res.dart';
import '../../core/utils/convert_digits_to_farsi.dart';
import '../../data/models/place.dart';
import '../../domain/riverpod/data/categories_items_provider.dart';

import '../../domain/riverpod/screen/loading_circularPRI_provider.dart';
import '../pages/detials_page.dart';

import '.IncrementallyLoadingListView.dart';

class CategoryItem extends ConsumerStatefulWidget {
  final String id;
  const CategoryItem({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryItemState();
}

class _CategoryItemState extends ConsumerState<CategoryItem> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      await ref.read(categoriesItemsProvider.notifier).getInitPlaces(widget.id);
      ref.read(loadingProvider.notifier).state = !ref.watch(loadingProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.width;
    final data = ref.watch(categoriesItemsProvider);
    debugPrint('Ui is load : $data');
    final place = ref.read(categoriesItemsProvider
        .notifier); // need to change to better clean code
    final places = data.map((e) => e).toList();
    return ref.watch(loadingProvider)
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.blueGrey,
              strokeWidth: 5,
            ),
          )
        : IncrementallyLoadingListView(
            shrinkWrap: true,
            hasMore: () => ref.read(hasMore),
            itemCount: () => places.length,
            loadMore: () async => await place.getPlaces(widget.id),
            itemBuilder: (context, index) {
              final phone = places[index].adresses[0].phone;
              final phoneNumber = convertDigitsToFarsi(phone);
              final items = places[index];
              if (index == places.length - 1 && (ref.watch(hasMore))) {
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
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(id: places[index].id),
          ),
        );
        FirebaseAnalytics.instance.logEvent(
          name: 'humm_1',
          parameters: <String, dynamic>{
            'clicked_on': "${places[index].name}",
          },
        );
      },
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
                          Image.asset(ImageRes.asanYab),
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
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16.0),
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
