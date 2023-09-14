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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  'مکان های نزدیک',
                  style: TextStyle(color: Colors.grey, fontSize: 20.0),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: screenHeight * 0.25,
                width: screenWidth,
                child: ListView.separated(
                    padding: const EdgeInsets.only(left: 12),
                    scrollDirection: Axis.horizontal,
                    reverse: true,
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
                                              image: NetworkImage(
                                                  place[index].coverImage))),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: Text(
                                      place[index].category!,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: Text(
                                      place[index].name!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.indigo.withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.grey,
                                      ),
                                      Flexible(
                                        child: Text(
                                          place[index].adresses[0].address,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                    separatorBuilder: (context, index) => const SizedBox(
                          width: 5,
                        ),
                    itemCount: place.length >= 5 ? 5 : place.length),
              ),
            ],
          );
  }
}
