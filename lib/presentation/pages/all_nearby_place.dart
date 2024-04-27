import 'package:asan_yab/data/models/language.dart';
import 'package:asan_yab/domain/riverpod/config/internet_connectivity_checker.dart';
import 'package:asan_yab/presentation/widgets/button_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/utils/convert_digits_to_farsi.dart';
import '../../core/utils/utils.dart';
import '../../data/models/place.dart';
import '../../data/repositoris/language_repository.dart';
import '../../domain/riverpod/data/single_place_provider.dart';
import '../../domain/riverpod/screen/drop_Down_Buton.dart';
import '../../domain/servers/nearby_places.dart';
import '../pages/detials_page.dart';

final isConnectedLocation = StateProvider<bool>((ref) => false);

final isExpand = StateProvider<bool>((ref) => false);

class NearbyPlacePage extends ConsumerStatefulWidget {
  const NearbyPlacePage({super.key});

  @override
  ConsumerState<NearbyPlacePage> createState() => _NearbyPlacePageState();
}

class _NearbyPlacePageState extends ConsumerState<NearbyPlacePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final languageText = AppLocalizations.of(context);
    final isRTL = ref.watch(languageProvider).code == 'fa';
    final List<Place> place;
    place = ref.watch(nearbyPlace);

    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity! > 10) {
          FocusScope.of(context).unfocus();
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            title: Text(
              languageText!.nearby_place_page_title,
            ),
            leading: IconButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back, size: 25),
            ),
          ),
          body:Utils.netIsConnected(ref)? place.isEmpty
              ? Center(
                  child: ref.watch(isConnectedLocation)
                      ? const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 5,
                            color: Colors.red,
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: ButtonWidget(
                              onClicked: () async {
                                await ref
                                    .refresh(nearbyPlace.notifier)
                                    .refresh();
                              },
                              titleName: languageText
                                  .nearby_place_page_active_location,
                              textColor1: Colors.white,
                              btnColor: Colors.black26),
                        ))
              : RefreshIndicator(
                  onRefresh: () async {
                    await Future.delayed(const Duration(seconds: 2)).then(
                        (value) => ref.watch(nearbyPlace.notifier).refresh());

                    ref.read(isConnectedLocation.notifier).state =
                        await Geolocator.isLocationServiceEnabled();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    verticalDirection: VerticalDirection.down,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(languageText.nearby_place_page_distances),
                            const SizedBox(
                              width: 10,
                            ),
                            DropdownButton<double>(
                              iconSize: 34,
                              selectedItemBuilder: (context) => List.generate(
                                ref
                                    .read(valueOfDropButtonProvider.notifier)
                                    .distance
                                    .length,
                                (index) => SizedBox(
                                  width: 120,
                                  child: isRTL
                                      ? Padding(
                                          padding: const EdgeInsets.all(13.0),
                                          child: Text(
                                            "  ${convertDigitsToFarsi((ref.read(valueOfDropButtonProvider.notifier).distance[index] < 1 ? (ref.read(valueOfDropButtonProvider.notifier).distance[index] * 1000).toInt().toString() : ref.read(valueOfDropButtonProvider.notifier).distance[index].toInt().toString()))} ${ref.read(valueOfDropButtonProvider.notifier).distance[index] < 1 ? languageText.nearby_place_page_meter : languageText.nearby_place_page_km}",
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(13.0),
                                          child: Text(
                                            "  ${(ref.read(valueOfDropButtonProvider.notifier).distance[index] < 1 ? (ref.read(valueOfDropButtonProvider.notifier).distance[index] * 1000).toInt().toString() : ref.read(valueOfDropButtonProvider.notifier).distance[index].toInt().toString())} ${ref.read(valueOfDropButtonProvider.notifier).distance[index] < 1 ? languageText.nearby_place_page_meter : languageText.nearby_place_page_km}",
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                        ),
                                ),
                              ),
                              value: ref.watch(valueOfDropButtonProvider),
                              items: ref
                                  .read(valueOfDropButtonProvider.notifier)
                                  .distance
                                  .map((e) {
                                return DropdownMenuItem<double>(
                                  value: e,
                                  onTap: () async {
                                    ref.refresh(nearbyPlace.notifier).refresh();
                                    ref
                                            .read(isConnectedLocation.notifier)
                                            .state =
                                        await Geolocator
                                            .isLocationServiceEnabled();
                                    await Future.delayed(
                                        const Duration(seconds: 1));
                                  },
                                  child: isRTL
                                      ? Row(
                                          children: [
                                            Radio<double>(
                                              activeColor: Colors.green,
                                              value: e,
                                              groupValue: ref.watch(
                                                  valueOfDropButtonProvider),
                                              onChanged: (value) {
                                                ref
                                                    .read(
                                                        valueOfDropButtonProvider
                                                            .notifier)
                                                    .choiceDistacne(value!);
                                              },
                                              fillColor: MaterialStateProperty
                                                  .resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                                  if (states.contains(
                                                      MaterialState.selected)) {
                                                    return Colors.green;
                                                  }
                                                  return Colors.grey;
                                                },
                                              ),
                                            ),
                                            Text(
                                              "  ${convertDigitsToFarsi((e < 1 ? (e * 1000).toInt().toString() : e.toInt().toString()))} ${e < 1 ? languageText.nearby_place_page_meter : languageText.nearby_place_page_km}",
                                            ),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Radio<double>(
                                              activeColor: Colors.green,
                                              value: e,
                                              groupValue: ref.watch(
                                                  valueOfDropButtonProvider),
                                              onChanged: (value) {
                                                ref
                                                    .read(
                                                        valueOfDropButtonProvider
                                                            .notifier)
                                                    .choiceDistacne(value!);
                                              },
                                              fillColor: MaterialStateProperty
                                                  .resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                                  if (states.contains(
                                                      MaterialState.selected)) {
                                                    return Colors
                                                        .green; // selected color
                                                  }
                                                  return Colors
                                                      .white; // unselected color
                                                },
                                              ),
                                            ),
                                            Text(
                                              "  ${(e < 1 ? (e * 1000).toInt().toString() : e.toInt().toString())} ${e < 1 ? languageText.nearby_place_page_meter : languageText.nearby_place_page_km}",
                                            ),
                                          ],
                                        ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                ref
                                    .read(valueOfDropButtonProvider.notifier)
                                    .choiceDistacne(value!);
                              },
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
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
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                                  onTap: () async {
                                    ref.read(getSingleProvider.notifier).state =
                                        null;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetailsPage(id: place[index].id),
                                        ));
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            flex: 3,
                                            child: Container(
                                              width: 200,
                                              height: 200,
                                              padding: EdgeInsets.zero,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(12),
                                                  topRight: Radius.circular(12),
                                                  bottomLeft: Radius.elliptical(
                                                      100, 90),
                                                  bottomRight:
                                                      Radius.elliptical(
                                                          200, 20),
                                                ),
                                                shape: BoxShape.rectangle,
                                              ),
                                              child: place[index].coverImage !=
                                                          '' &&
                                                      place[index]
                                                          .coverImage
                                                          .isNotEmpty
                                                  ? CachedNetworkImage(
                                                      imageUrl: place[index]
                                                          .coverImage, // Use the placeholder image URL if the cover image is null
                                                      placeholder: (context,
                                                              url) =>
                                                          Image.asset(
                                                              'assets/asan_yab.png'), // Use the placeholder image while loading
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Image.asset(
                                                              'assets/asan_yab.png'),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.asset(
                                                      'assets/asan_yab.png'),
                                            ),
                                          ),
                                          const SizedBox(height: 10),

                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12),
                                            child: Text(
                                              place[index].name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          // Padding(
                                          //   padding: const EdgeInsets.symmetric(
                                          //       horizontal: 12),
                                          //   child: Text(
                                          //     place[index].category,
                                          //     overflow: TextOverflow.ellipsis,
                                          //     style: const TextStyle(
                                          //       color: Colors.grey,
                                          //     ),
                                          //   ),
                                          // ),
                                          const SizedBox(height: 10),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              child: Directionality(
                                                textDirection:
                                                    TextDirection.rtl,
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons
                                                          .location_on_outlined,
                                                      color: Colors.grey,
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        place[index]
                                                            .addresses[0]
                                                            .address,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )),
                                          const SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.redAccent
                                                      .withOpacity(0.7),
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              padding: const EdgeInsets.all(8),
                                              child: Directionality(
                                                textDirection: isRTL
                                                    ? TextDirection.rtl
                                                    : TextDirection.ltr,
                                                child: Text(
                                                  place[index].distance < 1000
                                                      ? isRTL
                                                          ? '${convertDigitsToFarsi(place[index].distance.toString())} ${languageText.nearby_place_page_meter_away}'
                                                          : '${place[index].distance.toString()} ${languageText.nearby_place_page_meter_away}'
                                                      : isRTL
                                                          ? '${convertDigitsToFarsi((place[index].distance / 1000).toStringAsFixed(1))} ${languageText.nearby_place_page_km_away}'
                                                          : '${(place[index].distance / 1000).toStringAsFixed(1)} ${languageText.nearby_place_page_km_away}',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            itemCount: place.length),
                      ),
                    ],
                  ),
                )
      :const Center(child: CircularProgressIndicator(
            color: Colors.red,
          ),)
      ),
    );
  }
}
