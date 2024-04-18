import 'package:asan_yab/core/extensions/language.dart';
import 'package:asan_yab/core/routes/routes.dart';
import 'package:asan_yab/core/utils/translation_util.dart';
import 'package:asan_yab/domain/servers/nearby_places.dart';
import 'package:asan_yab/presentation/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../core/utils/convert_digits_to_farsi.dart';
import '../../data/models/place.dart';
import '../../data/repositoris/language_repo.dart';
import '../../domain/riverpod/screen/value_of_nearby_drop_Down_Button.dart';

final isConnectedLocation = StateProvider<bool>((ref) => false);

class NearbyPlacePage extends ConsumerWidget {
  const NearbyPlacePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = texts(context);
    final isRTL = ref.watch(languageProvider).code == 'fa';
    final List<Place> place;
    place = ref.watch(nearbyPlacesProvider);

    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(text.nearby_place_page_title),
          leading: IconButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              context.pop();
            },
            icon: const Icon(Icons.arrow_back, size: 25),
          ),
        ),
        body: place.isEmpty
            ? Center(
                child: ref.watch(isConnectedLocation)
                    ? Center(
                        child: LoadingAnimationWidget.fourRotatingDots(
                            color: Colors.redAccent, size: 60),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: ButtonWidget(
                          onClicked: () async => await ref
                              .refresh(nearbyPlacesProvider.notifier)
                              .refresh(),
                          titleName: text.nearby_place_page_active_location,
                          textColor1: Colors.white,
                          btnColor: Colors.black26,
                        ),
                      ),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 2)).then(
                      (value) =>
                          ref.watch(nearbyPlacesProvider.notifier).refresh());

                  ref.read(isConnectedLocation.notifier).state =
                      await Geolocator.isLocationServiceEnabled();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  verticalDirection: VerticalDirection.down,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [
                          Text(text.nearby_place_page_distances),
                          SizedBox(width: 10.w),
                          DropdownButton(
                              iconSize: 24,
                              value: ref.watch(valueOfDropButtonProvider),
                              items: ref
                                  .read(valueOfDropButtonProvider.notifier)
                                  .distance
                                  .map((e) {
                                return DropdownMenuItem(
                                    onTap: () async {
                                      ref
                                          .refresh(
                                              nearbyPlacesProvider.notifier)
                                          .refresh();
                                      ref
                                              .read(isConnectedLocation.notifier)
                                              .state =
                                          await Geolocator
                                              .isLocationServiceEnabled();
                                      await Future.delayed(
                                          const Duration(seconds: 1));
                                    },
                                    value: e,
                                    child: isRTL
                                        ? Text("  ${convertDigitsToFarsi(
                                            (e < 1
                                                ? (e * 1000).toInt().toString()
                                                : e.toInt().toString()),
                                          )} ${e < 1 ? text.nearby_place_page_meter : text.nearby_place_page_km}")
                                        : Text(
                                            "  ${(e < 1 ? (e * 1000).toInt().toString() : e.toInt().toString())} ${e < 1 ? text.nearby_place_page_meter : text.nearby_place_page_km}"));
                              }).toList(),
                              onChanged: (value) {
                                ref
                                    .read(valueOfDropButtonProvider.notifier)
                                    .choiceDistance(value!);
                              }),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Flexible(
                      child: GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                childAspectRatio: 0.7,
                                maxCrossAxisExtent: 300,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10),
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            context.pushNamed(Routes.details,
                                pathParameters: {'placeId': place[index].id});
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: Container(
                                    width: 200,
                                    height: 200,
                                    padding: EdgeInsets.zero,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                          bottomLeft:
                                              Radius.elliptical(100, 90),
                                          bottomRight:
                                              Radius.elliptical(200, 20)),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            place[index].coverImage),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text(
                                    place[index].category,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text(
                                    place[index].name,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.indigo.withOpacity(0.6),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.grey,
                                      ),
                                      Flexible(
                                        child: Text(
                                          place[index].addresses[0].address,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color:
                                            Colors.redAccent.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      place[index].distance < 1000
                                          ? isRTL
                                              ? '${convertDigitsToFarsi(place[index].distance.toString())} ${text.nearby_place_page_meter_away}'
                                              : '${place[index].distance.toString()} ${text.nearby_place_page_meter_away}'
                                          : isRTL
                                              ? '${convertDigitsToFarsi((place[index].distance / 1000).toStringAsFixed(1))} ${text.nearby_place_page_km_away}'
                                              : '${(place[index].distance / 1000).toStringAsFixed(1)} ${text.nearby_place_page_km_away}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                              ],
                            ),
                          ),
                        ),
                        itemCount: place.length,
                      ),
                    ),
                  ],
                ),
              ));
  }
}
