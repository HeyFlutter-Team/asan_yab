import 'package:asan_yab/core/routes/routes.dart';
import 'package:asan_yab/core/utils/convert_digits_to_farsi.dart';
import 'package:asan_yab/core/extensions/language.dart';
import 'package:asan_yab/domain/riverpod/data/fetch_places.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../core/res/image_res.dart';
import '../../data/repositoris/language_repo.dart';
import '../../domain/riverpod/data/categories_items.dart';
import '../../domain/riverpod/screen/circular_loading_provider.dart';

final idProvider = StateProvider((ref) => '');

class CategoryItemWidget extends ConsumerStatefulWidget {
  final String id;
  const CategoryItemWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryItemState();
}

class _CategoryItemState extends ConsumerState<CategoryItemWidget> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      debugPrint('id for cat ${widget.id}');
      ref.read(idProvider.notifier).state = widget.id;
      Future.delayed(
        const Duration(milliseconds: 100),
        () {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            ref.read(fetchPlacesProvider.notifier).loadMoreData();
          });
        },
      );
      await ref.read(categoriesItemsProvider.notifier).getInitPlaces(widget.id);
      ref.read(circularLoadingProvider.notifier).toggleCircularLoading();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.width;
    final data = ref.watch(categoriesItemsProvider);
    final isRTL = ref.watch(languageProvider).code == 'fa';
    return ref.watch(loadingDataProvider) || ref.watch(circularLoadingProvider)
        ? Center(
            child: LoadingAnimationWidget.fourRotatingDots(
                color: Colors.redAccent, size: 60),
          )
        : ListView.builder(
            controller: ref.read(fetchPlacesProvider.notifier).scrollController,
            itemCount: ref.watch(hasMore) ? (data.length + 1) : data.length,
            itemBuilder: (context, index) {
              if (index < data.length) {
                return InkWell(
                  onTap: () {
                    context.pushNamed(Routes.details,
                        pathParameters: {'placeId': data[index].id});

                    FirebaseAnalytics.instance.logEvent(
                      name: 'humm_1',
                      parameters: <String, dynamic>{
                        'clicked_on': data[index].name,
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
                                  imageUrl: data[index].logo,
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
                            padding:
                                const EdgeInsets.only(right: 12.0, left: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data[index].name,
                                  overflow: TextOverflow.fade,
                                  maxLines: 2,
                                  style: const TextStyle(fontSize: 18.0),
                                ),
                                SizedBox(height: 12.0.h),
                                data[index].addresses[0].phone.isEmpty
                                    ? const SizedBox()
                                    : SizedBox(
                                        width: 180.w,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.black.withOpacity(0.3),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                          onPressed: () async =>
                                              await FlutterPhoneDirectCaller
                                                  .callNumber(data[index]
                                                      .addresses[0]
                                                      .phone),
                                          child: isRTL
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      isRTL
                                                          ? convertDigitsToFarsi(
                                                              data[index]
                                                                  .addresses
                                                                  .first
                                                                  .phone)
                                                          : data[index]
                                                              .addresses
                                                              .first
                                                              .phone,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.0),
                                                    ),
                                                    const Icon(
                                                      Icons.phone_android,
                                                      color: Colors.green,
                                                      size: 25,
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    const Icon(
                                                      Icons.phone_android,
                                                      color: Colors.green,
                                                      size: 25,
                                                    ),
                                                    Text(
                                                      isRTL
                                                          ? convertDigitsToFarsi(
                                                              data[index]
                                                                  .addresses
                                                                  .first
                                                                  .phone)
                                                          : data[index]
                                                              .addresses
                                                              .first
                                                              .phone,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.0),
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
              } else if (index == data.length) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                        color: Colors.redAccent, size: 60),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          );
  }
}
