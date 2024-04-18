import 'package:asan_yab/core/routes/routes.dart';
import 'package:asan_yab/core/utils/convert_digits_to_farsi.dart';
import 'package:asan_yab/core/extensions/language.dart';
import 'package:asan_yab/core/utils/translation_util.dart';
import 'package:asan_yab/domain/servers/nearby_places.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/place.dart';
import '../../data/repositoris/language_repo.dart';

class NearbyPlaceWidget extends ConsumerWidget {
  const NearbyPlaceWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Place> place;
    place = ref.watch(nearbyPlacesProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final text = texts(context);
    final isRTL = ref.watch(languageProvider).code == 'fa';
    return place.isEmpty
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      text.nearbyPlaces_title,
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 20.0),
                    ),
                    IconButton(
                      onPressed: () => context.pushNamed(Routes.nearbyPlace),
                      icon: Icon(
                        isRTL
                            ? Icons.arrow_circle_left_outlined
                            : Icons.arrow_circle_right_outlined,
                        size: 32.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                height: screenHeight * 0.3.h,
                width: screenWidth,
                child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => SizedBox(
                          width: screenWidth * 0.5.w,
                          child: InkWell(
                            onTap: () {
                              context.pushNamed(
                                Routes.details,
                                pathParameters: {'placeId': place[index].id},
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Container(
                                      width: 200,
                                      height: 200,
                                      padding: EdgeInsets.zero,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.circular(12),
                                            bottomLeft:
                                                Radius.elliptical(200, 90),
                                            bottomRight:
                                                Radius.elliptical(200, 20)),
                                        shape: BoxShape.rectangle,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(ref
                                              .watch(
                                                  nearbyPlacesProvider)[index]
                                              .coverImage),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                            horizontal: 12)
                                        .copyWith(top: 10),
                                    child: Text(
                                      ref
                                          .watch(nearbyPlacesProvider)[index]
                                          .category,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Text(
                                      ref
                                          .watch(nearbyPlacesProvider)[index]
                                          .name,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.grey,
                                      ),
                                      Flexible(
                                        child: Text(
                                          ref
                                              .watch(
                                                  nearbyPlacesProvider)[index]
                                              .addresses[0]
                                              .address,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color:
                                              Colors.redAccent.withOpacity(0.7),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      padding: const EdgeInsets.all(8),
                                      child: isRTL
                                          ? Text(
                                              '${convertDigitsToFarsi(place[index].distance.toString())} ${text.nearbyPlaces_meter_title}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Text(
                                              '${place[index].distance} ${text.nearbyPlaces_meter_title}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                ],
                              ),
                            ),
                          ),
                        ),
                    separatorBuilder: (context, index) => SizedBox(width: 5.w),
                    itemCount: ref.watch(nearbyPlacesProvider).length >= 5
                        ? 5
                        : ref.watch(nearbyPlacesProvider).length),
              ),
            ],
          );
  }
}
