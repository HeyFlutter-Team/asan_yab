import 'package:asan_yab/data/models/language.dart';
import 'package:asan_yab/domain/riverpod/screen/active_index.dart';
import 'package:asan_yab/presentation/widgets/phone_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../core/res/image_res.dart';
import '../../core/utils/convert_digits_to_farsi.dart';
import '../../data/models/place.dart';

import '../../data/repositoris/language_repository.dart';
import '../../domain/riverpod/data/places_provider.dart';
import '../../domain/riverpod/data/single_place_provider.dart';
import '../pages/detials_page.dart';

class NewPlaces extends ConsumerWidget {
  final RefreshCallback onRefresh;
  NewPlaces({super.key, required this.onRefresh});

  final CarouselController pageController = CarouselController();

  //
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(placeProvider.notifier).getPlaces();
    final screenHeight = MediaQuery.of(context).size.height;
    List<Place> places = ref.watch(placeProvider);
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: places.isEmpty
          ? const SizedBox(
              height: 0,
            )
          : Stack(
              children: [
                CarouselSlider.builder(
                  itemCount: places.length >= 5 ? 5 : places.length,
                  itemBuilder: (context, index, realIndex) {
                    final phoneNumberItems = places[index].addresses[0].phone;
                    final items = places[index];
                    final isRTL = ref.watch(languageProvider).code == 'fa';
                    final phoneNumber = isRTL
                        ? convertDigitsToFarsi(phoneNumberItems)
                        : phoneNumberItems;
                    return GestureDetector(
                      onTap: () async {
                        ref.read(getSingleProvider.notifier).state = null;

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailsPage(id: places[index].id),
                            ));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                placeholder: (context, url) =>
                                    Image.asset(ImageRes.asanYab),
                                imageUrl: items.coverImage.url!,
                                fit: BoxFit.cover,
                                height: double.infinity,
                                width: double.infinity,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            Positioned(
                              top: 40,
                              right: 40,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Text(
                                      items.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  phoneNumber.isEmpty
                                      ? const SizedBox()
                                      : Directionality(
                                          textDirection: isRTL
                                              ? TextDirection.rtl
                                              : TextDirection.ltr,
                                          child: buildPhoneNumberWidget(
                                              context: context,
                                              isRTL: isRTL,
                                              phone: phoneNumber,
                                              colorActive: true),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  carouselController: pageController,
                  options: CarouselOptions(
                    height: screenHeight * 0.25,
                    enlargeCenterPage: true,
                    reverse: false,
                    autoPlayInterval: const Duration(seconds: 4),
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 500),
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      ref.read(activeIndexNotifier.notifier).activeIndex(index);
                    },
                  ),
                ),
                Positioned(
                    bottom: 30,
                    left: 35,
                    child: AnimatedSmoothIndicator(
                      count: places.length >= 5 ? 5 : places.length,
                      activeIndex: ref.watch(activeIndexNotifier),
                      effect: const ExpandingDotsEffect(
                        dotHeight: 12,
                        dotWidth: 12,
                        activeDotColor: Colors.white,
                        dotColor: Colors.white30,
                      ),
                    )),
              ],
            ),
    );
  }
}
