import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/place.dart';
import '../../domain/servers/nearby_places.dart';
import '../pages/detials_page.dart';

class NearbyPlacePage extends ConsumerStatefulWidget {
  const NearbyPlacePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NearbyPlaceState();
}

class _NearbyPlaceState extends ConsumerState<NearbyPlacePage> {
  late List<Place> place;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    place = ref.watch(nearbyPlace);
    // place.take(5);
    // final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;
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
        body: ref.watch(nearbyPlace).isEmpty
            ? const SizedBox()
            : RefreshIndicator(
                onRefresh: () async =>
                    ref.refresh(nearbyPlace.notifier).refresh(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  verticalDirection: VerticalDirection.down,
                  children: [
                    Flexible(
                      child: GridView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20),
                          itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailsPage(
                                            id: ref
                                                .watch(nearbyPlace)[index]
                                                .id),
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
                                                  image: NetworkImage(ref
                                                      .watch(nearbyPlace)[index]
                                                      .coverImage))),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Text(
                                          ref
                                              .watch(nearbyPlace)[index]
                                              .category!,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Text(
                                          ref.watch(nearbyPlace)[index].name!,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color:
                                                Colors.indigo.withOpacity(0.6),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
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
                                                ref
                                                    .watch(nearbyPlace)[index]
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
                                    ],
                                  ),
                                ),
                              ),
                          itemCount: ref.watch(nearbyPlace).length),
                    ),
                  ],
                ),
              ));
  }
}
