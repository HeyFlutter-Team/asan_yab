import 'package:asan_yab/presentation/pages/all_nearby_place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/place.dart';
import '../../domain/servers/nearby_places.dart';
import '../pages/detials_page.dart';

class NearbyPlaceWidget extends ConsumerStatefulWidget {
  const NearbyPlaceWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NearbyPlaceWidgetState();
}

class _NearbyPlaceWidgetState extends ConsumerState<NearbyPlaceWidget> {
  late List<Place> place;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    place = ref.watch(nearbyPlace);

    // place.take(5);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
                    const Text(
                      'مکان های نزدیک',
                      style: TextStyle(color: Colors.grey, fontSize: 20.0),
                    ),
                    IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NearbyPlacePage()),
                      ),
                      icon: const Icon(
                        Icons.arrow_circle_left_outlined,
                        size: 32.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: screenHeight * 0.25,
                width: screenWidth,
                child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => SizedBox(
                          height: screenHeight * 0.25,
                          width: screenWidth * 0.5,
                          child: InkWell(
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
                                                  .watch(nearbyPlace)[index]
                                                  .coverImage))),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Text(
                                      ref.watch(nearbyPlace)[index].category!,
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
                                      ref.watch(nearbyPlace)[index].name!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.indigo.withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.grey,
                                      ),
                                      Flexible(
                                        child: Text(
                                          ref
                                              .watch(nearbyPlace)[index]
                                              .adresses[0]
                                              .address,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ),
                    separatorBuilder: (context, index) => const SizedBox(
                          width: 5,
                        ),
                    itemCount: ref.watch(nearbyPlace).length >= 5
                        ? 5
                        : ref.watch(nearbyPlace).length),
              ),
            ],
          );
  }
}
