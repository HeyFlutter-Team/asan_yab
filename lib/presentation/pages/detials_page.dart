import 'package:asan_yab/core/extensions/language.dart';
import 'package:asan_yab/core/utils/translation_util.dart';
import 'package:asan_yab/domain/riverpod/data/favorite_item.dart';
import 'package:asan_yab/domain/riverpod/data/single_place.dart';
import 'package:asan_yab/domain/riverpod/data/toggle_favorite.dart';

import 'package:asan_yab/presentation/widgets/comments_widget.dart';
import 'package:asan_yab/presentation/widgets/rating_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../core/res/image_res.dart';
import '../../core/routes/routes.dart';
import '../../core/utils/convert_digits_to_farsi.dart';
import '../../data/repositoris/language_repo.dart';
import '../../domain/riverpod/data/firbase_favorite_provider.dart';
import '../../domain/riverpod/data/firebase_rating_provider.dart';

import '../widgets/cover_details_image_widget.dart';
import '../widgets/custom_cards_widget.dart';
import '../widgets/details_gallery_widget.dart';
import '../widgets/details_information_widget.dart';
import '../widgets/header_details_widget.dart';

import 'package:go_router/go_router.dart';

import '../widgets/show_doctors_details_widget.dart';

class DetailsPage extends ConsumerStatefulWidget {
  final String id;

  const DetailsPage({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DetailsPageState();
}

class _DetailsPageState extends ConsumerState<DetailsPage> {
  @override
  void initState() {
    super.initState();
    ref.read(singlePlaceProvider.notifier).fetchSinglePlace(widget.id);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.read(getFavoriteProvider).getFavorite();
      final provider = ref.read(favoriteItemProvider.notifier);
      final toggle = provider.isExist(widget.id);
      ref.read(toggleFavoriteProvider.notifier).toggle(toggle);

      ref
          .read(firebaseRatingProvider.notifier)
          .getAverageRating(postId: widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> phoneData = [];
    List<String> addressData = [];
    ref.read(firebaseRatingProvider.notifier);
    final size = MediaQuery.of(context).size;

    final provider = ref.read(favoriteItemProvider.notifier);
    final isRTL = ref.watch(languageProvider).code == 'fa';
    final places = ref.watch(singlePlaceProvider);
    final text = texts(context);
    return Scaffold(
      body: places == null
          ? Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.redAccent, size: 60),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 35.h),
                HeaderDetailsWidget(
                  ref: ref,
                  widget: widget,
                  places: places,
                  provider: provider,
                  addressData: addressData,
                  phoneData: phoneData,
                  text: text,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 40, top: 12),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 10.h),
                            (places.coverImage == '')
                                ? LoadingAnimationWidget.fourRotatingDots(
                                    color: Colors.redAccent, size: 60)
                                : CoverDetailsImagewidget(
                                    places: places, size: size),
                            SizedBox(height: 20.h),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                places.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                            RatingWidget(postId: places.id),
                            CommentsWidget(postId: places.id),
                            SizedBox(height: 12.h),
                            (places.description == '' ||
                                    places.description.isEmpty)
                                ? const SizedBox()
                                : CustomCardsWidget(
                                    title: text.details_page_1_custom_card,
                                    child: Text(places.description),
                                  ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: (places.gallery.isEmpty)
                                  ? const SizedBox()
                                  : Row(
                                      children: [
                                        const Icon(Icons.library_books),
                                        SizedBox(width: 8.w),
                                        Text(
                                          text.details_page_2_custom_card,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 12.h)
                                      ],
                                    ),
                            ),
                            places.gallery.isEmpty
                                ? SizedBox(height: 0.h)
                                : DetailsGalleryWidget(
                                    size: size, places: places),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: (places.itemImages == null ||
                                      places.itemImages!.isEmpty)
                                  ? const SizedBox()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            text.details_page_4_custom_card,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => context
                                              .pushNamed(Routes.itemShop),
                                          icon: Icon(
                                            isRTL
                                                ? Icons
                                                    .arrow_circle_left_outlined
                                                : Icons
                                                    .arrow_circle_right_outlined,
                                            size: 30,
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        SizedBox(height: 12.h)
                                      ],
                                    ),
                            ),
                            SizedBox(height: 5.h),
                            places.itemImages == null ||
                                    places.itemImages!.isEmpty
                                ? SizedBox(height: 0.h)
                                : SizedBox(
                                    height: size.height * 0.25.h,
                                    child: ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          SizedBox(width: 20.w),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: places.itemImages!.length >= 5
                                          ? 5
                                          : places.itemImages!.length,
                                      itemBuilder: (context, index) => Padding(
                                        padding: const EdgeInsets.only(
                                          top: 6,
                                          left: 2,
                                          right: 2,
                                          bottom: 18,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            context.pushNamed(Routes.imageView,
                                                pathParameters: {
                                                  'index': index.toString(),
                                                  'imageList': places
                                                      .itemImages!
                                                      .map((item) =>
                                                          item.imageUrl)
                                                      .toList()
                                                      .toString(),
                                                });
                                          },
                                          child: Container(
                                            width: size.width * 0.25,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? Colors.grey
                                                      .shade100 // Set light theme color
                                                  : Colors.black12,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(30),
                                                    topLeft:
                                                        Radius.circular(30),
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10),
                                                  ),
                                                  child: CachedNetworkImage(
                                                    imageUrl: places
                                                        .itemImages![index]
                                                        .imageUrl,
                                                    width: size.width * 0.24,
                                                    height: size.height * 0.13,
                                                    fit: BoxFit.cover,
                                                    placeholder:
                                                        (context, url) =>
                                                            Image.asset(
                                                      ImageRes.asanYab,
                                                      height: 170,
                                                      width: 130,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 8.h),
                                                Text(
                                                  maxLines: 1,
                                                  places
                                                      .itemImages![index].name,
                                                  style: const TextStyle(
                                                    overflow: TextOverflow.fade,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 4.h),
                                                RichText(
                                                  overflow: TextOverflow.clip,
                                                  maxLines: 1,
                                                  text: isRTL
                                                      ? TextSpan(children: [
                                                          TextSpan(
                                                            text:
                                                                '${convertDigitsToFarsi(places.itemImages![index].price)} ',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .green
                                                                  .shade500,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: 'افغانی',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors
                                                                  .green
                                                                  .shade500,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          )
                                                        ])
                                                      : TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  '${places.itemImages![index].price} ',
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .green
                                                                    .shade500,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: 'AF',
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .green
                                                                    .shade500,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            SizedBox(height: 8.h),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: (places.doctors == null ||
                                      places.doctors!.isEmpty)
                                  ? const SizedBox()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            text.details_page_7_custom_card,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () =>
                                              context.pushNamed(Routes.doctors),
                                          icon: Icon(
                                            isRTL
                                                ? Icons
                                                    .arrow_circle_left_outlined
                                                : Icons
                                                    .arrow_circle_right_outlined,
                                            size: 30,
                                          ),
                                        ),
                                        const SizedBox(height: 12)
                                      ],
                                    ),
                            ),
                            SizedBox(height: 5.h),
                            places.doctors == null || places.doctors!.isEmpty
                                ? SizedBox(height: 0.h)
                                : ShowDoctorsDetailsWidget(
                                    size: size,
                                    places: places,
                                    text: text,
                                    isRTL: isRTL),
                            (places.addresses.isEmpty)
                                ? const SizedBox()
                                : DetailsInformationWidget(
                                    text: text,
                                    places: places,
                                    phoneData: phoneData,
                                    addressData: addressData,
                                    isRTL: isRTL),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
