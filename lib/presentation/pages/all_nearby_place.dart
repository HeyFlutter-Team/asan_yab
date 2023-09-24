import 'package:asan_yab/presentation/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/utils/convert_digits_to_farsi.dart';
import '../../data/models/place.dart';
import '../../domain/riverpod/screen/drop_Down_Buton.dart';
import '../../domain/servers/nearby_places.dart';
import '../pages/detials_page.dart';

final isConnectedLocation = StateProvider<bool>((ref) => false);

class NearbyPlacePage extends ConsumerWidget {
  const NearbyPlacePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Place> place;
    place = ref.watch(nearbyPlace);

    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: const Text(
            'مکان های نزدیک',
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 25),
          ),
        ),
        body: place.isEmpty
            ? Center(
                child: ref.watch(isConnectedLocation)
                    ? const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 5,
                          color: Colors.blueGrey,
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: ButtonWidget(
                            onClicked: () async {
                              await ref.refresh(nearbyPlace.notifier).refresh();
                            },
                            titleName: 'لوکشن خود را فعال کنید',
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
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [
                          const Text('فاصله مورد نظر خود را انتخاب کنید'),
                          const SizedBox(
                            width: 10,
                          ),
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
                                          .refresh(nearbyPlace.notifier)
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
                                    child: Text(
                                        "  ${convertDigitsToFarsi((e < 1 ? (e * 1000).toInt().toString() : e.toInt().toString()))} ${e < 1 ? 'متر' : "کیلومتر"}"));
                              }).toList(),
                              onChanged: (value) {
                                ref
                                    .read(valueOfDropButtonProvider.notifier)
                                    .choiceDistacne(value!);
                              }),
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
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetailsPage(id: place[index].id),
                                      ));
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        flex: 3,
                                        child: Container(
                                          width: 200,
                                          height: 200,
                                          padding: EdgeInsets.zero,
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius
                                                      .only(
                                                  topLeft: Radius.circular(12),
                                                  topRight: Radius.circular(12),
                                                  bottomLeft: Radius.elliptical(
                                                      100, 90),
                                                  bottomRight:
                                                      Radius.elliptical(
                                                          200, 20)),
                                              shape: BoxShape.rectangle,
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      place[index]
                                                          .coverImage))),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Text(
                                          '${place[index].category}',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Text(
                                          place[index].name!,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color:
                                                Colors.indigo.withOpacity(0.6),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
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
                                                place[index]
                                                    .adresses[0]
                                                    .address,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
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
                                          child: Text(
                                            place[index].distance < 1000
                                                ? '${convertDigitsToFarsi(place[index].distance.toString())} متر تا مقصد '
                                                : '${convertDigitsToFarsi((place[index].distance / 1000).toStringAsFixed(1))} کیلومتر تا مقصد',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ),
                          itemCount: place.length),
                    ),
                  ],
                ),
              ));
  }
}
