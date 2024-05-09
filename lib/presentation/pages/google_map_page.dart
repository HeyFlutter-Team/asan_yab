import 'dart:math';

import 'package:asan_yab/data/models/language.dart';
import 'package:asan_yab/data/models/place.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/utils/convert_digits_to_farsi.dart';
import '../../data/repositoris/language_repository.dart';
import '../../domain/riverpod/data/single_place_provider.dart';

class GoogleMapPage extends ConsumerStatefulWidget {
  const GoogleMapPage({super.key});

  @override
  ConsumerState<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends ConsumerState<GoogleMapPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeMode themeMode = Theme.of(context).brightness == Brightness.dark
        ? ThemeMode.dark
        : ThemeMode.light;

    final places = ref.watch(getSingleProvider);
    final isRTL = ref.watch(languageProvider).code == 'fa';
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topRight: Radius.circular(10), topLeft: Radius.circular(10)),
      child: Stack(
        children: [
          GoogleMap(
            scrollGesturesEnabled: false,
            zoomGesturesEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: _getCameraPosition(places!.addresses),
            markers: places.addresses.isNotEmpty
                ? _buildMarkers(places.addresses)
                : null!,
            mapType:
                themeMode == ThemeMode.dark ? MapType.hybrid : MapType.normal,
            // Pass appropriate map style based on theme mode
          ),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.95,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: GoogleMap(
                                  gestureRecognizers: <Factory<
                                      OneSequenceGestureRecognizer>>{
                                    Factory<VerticalDragGestureRecognizer>(
                                      () => VerticalDragGestureRecognizer(),
                                    ),
                                  },
                                  initialCameraPosition:
                                      _getCameraPosition(places.addresses),
                                  markers: _buildMarkers(places.addresses),
                                  scrollGesturesEnabled: true,
                                  zoomGesturesEnabled: true,
                                  zoomControlsEnabled: false,
                                  myLocationButtonEnabled: false,
                                  rotateGesturesEnabled: true,
                                  myLocationEnabled: false,
                                  mapToolbarEnabled: true,
                                  mapType: themeMode == ThemeMode.dark
                                      ? MapType.hybrid
                                      : MapType.normal, // Add this line
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.transparent,
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(10),
                          separatorBuilder: (context, index) =>
                              const Padding(padding: EdgeInsets.all(10)),
                          scrollDirection: Axis.horizontal,
                          itemCount: places.addresses.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.07,
                              width: MediaQuery.of(context).size.width * 0.73,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.black
                                    : Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.location_on_outlined,
                                          size: 25,
                                          color: Colors.blue,
                                        ),
                                        const SizedBox(width: 3),
                                        Flexible(
                                          flex: 2,
                                          child: Text(
                                            '${places.addresses[index].branch.isNotEmpty ? ' ${places.addresses[index].branch}: ' : ''} ${places.addresses[index].address}',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12.0, right: 12),
                                      child: Row(children: [
                                        (places.addresses[index].phone.isEmpty)
                                            ? const SizedBox(height: 0)
                                            : ConstrainedBox(
                                                constraints:
                                                    const BoxConstraints(
                                                  minWidth: 70,
                                                ),
                                                child: OutlinedButton(
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      8)),
                                                  onPressed: () async {
                                                    await FlutterPhoneDirectCaller
                                                        .callNumber(
                                                      places.addresses[index]
                                                          .phone,
                                                    );
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        isRTL
                                                            ? convertDigitsToFarsi(
                                                                places
                                                                    .addresses[
                                                                        index]
                                                                    .phone)
                                                            : places
                                                                .addresses[
                                                                    index]
                                                                .phone,
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .dark
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 4),
                                                      const Icon(
                                                        Icons
                                                            .phone_android_sharp,
                                                        color: Colors.green,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                        const SizedBox(width: 40),
                                        IconButton(
                                          onPressed: () {
                                            _openDirections(
                                                places.addresses[index]);
                                          },
                                          icon: const Icon(
                                            Icons.directions,
                                            size: 43,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 18,
                        left: 1,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                backgroundColor: Colors.grey.withOpacity(0.4)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.close,
                              size: 42,
                              color: Colors.white,
                            )),
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Set<Marker> _buildMarkers(List<Address> addresses) {
    return Set.from(
      addresses.map((address) {
        if (address.lat.isNotEmpty && address.lang.isNotEmpty) {
          return Marker(
            markerId: MarkerId('SourceLocation${address.lat}-${address.lang}'),
            icon: BitmapDescriptor.defaultMarker,
            position: LatLng(
              double.parse(address.lat),
              double.parse(address.lang),
            ),
            consumeTapEvents: true,
            onTap: () {
              String locationName = address.branch.isNotEmpty
                  ? '${address.branch}: ${address.address}'
                  : address.address;
              _onMarkerTapped(context, locationName);
            },
          );
        } else {
          return null;
        }
      }).where((marker) => marker != null),
    );
  }

  void _onMarkerTapped(BuildContext context, String locationName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            contentTextStyle: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 16,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.bold),
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
            content: Container(
              height: 50,
              width: 50,
              child: Center(
                  child: Text(
                locationName,
                maxLines: 2,
              )),
            ));
      },
    );
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

// Function to calculate the center point and zoom level of the map
  CameraPosition _getCameraPosition(List<Address> addresses) {
    if (addresses.isEmpty) {
      return const CameraPosition(
        target: LatLng(0, 0),
        zoom: 10.0, // Default zoom level if no addresses are available
      );
    }

    // Find the bounds of all markers
    double minLat = double.infinity;
    double maxLat = -double.infinity;
    double minLng = double.infinity;
    double maxLng = -double.infinity;

    for (var address in addresses) {
      double lat = double.parse(address.lat);
      double lng = double.parse(address.lang);
      minLat = min(lat, minLat);
      maxLat = max(lat, maxLat);
      minLng = min(lng, minLng);
      maxLng = max(lng, maxLng);
    }

    // Calculate the center point
    double centerLat = (minLat + maxLat) / 2;
    double centerLng = (minLng + maxLng) / 2;

    // Calculate the distance between the farthest markers
    double maxDistance = _calculateDistance(minLat, minLng, maxLat, maxLng);

    // Calculate the zoom level based on the distance
    double zoom = _calculateZoomLevel(maxDistance);

    return CameraPosition(
      target: LatLng(centerLat, centerLng),
      zoom: zoom,
    );
  }

// Function to calculate the zoom level based on the distance between markers
  double _calculateZoomLevel(double distance) {
    const double defaultZoom =
        14.0; // Default zoom level if no distance is calculated
    const double maxZoom = 14.0; // Maximum allowed zoom level

    if (distance <= 0) {
      return defaultZoom;
    }

    // Adjust the zoom level based on the distance between markers
    double zoom = 12.0 - log(distance / 10) / log(2);

    // Ensure the zoom level does not exceed the maximum allowed zoom
    return min(zoom, maxZoom);
  }

  void _openDirections(Address address) async {
    // Check if the coordinates are available
    if (address.lat.isNotEmpty && address.lang.isNotEmpty) {
      // Construct the Google Maps URL with the destination coordinates
      final url =
          'https://www.google.com/maps/dir/?api=1&destination=${address.lat},${address.lang}';

      // Launch the URL
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }
}
