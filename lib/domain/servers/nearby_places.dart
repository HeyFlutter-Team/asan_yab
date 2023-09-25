import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/models/place.dart';
import '../../data/repositoris/places_rep.dart';
import '../riverpod/screen/drop_Down_Buton.dart';

final nearbyPlace = StateNotifierProvider<NearbyPlace, List<Place>>(
    (ref) => NearbyPlace([], ref));

class NearbyPlace extends StateNotifier<List<Place>> {
  final Ref ref;
  final placeRepository = PlacesRepository();
  List<Place> nearestLocations = [];
  void nearPlace() => state = nearestLocations;
  NearbyPlace(super.state, this.ref);
  double degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Radius of the Earth in kilometers
    final double lat1Rad = degreesToRadians(lat1);
    final double lon1Rad = degreesToRadians(lon1);
    final double lat2Rad = degreesToRadians(lat2);
    final double lon2Rad = degreesToRadians(lon2);

    final double dLat = lat2Rad - lat1Rad;
    final double dLon = lon2Rad - lon1Rad;

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  // double baseLat, double baseLng
  Future<List<Place>> getNearestLocations() async {
    Position? currentLocation;
    late bool servicePremission = false;
    late LocationPermission permission;

    Future<Position> getCurrentLocation() async {
      servicePremission = await Geolocator.isLocationServiceEnabled();
      if (!servicePremission) {
        debugPrint('servies disabled');
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      return await Geolocator.getCurrentPosition();
    }

    currentLocation = await getCurrentLocation();

    double maxDistance =
        ref.watch(valueOfDropButtonProvider); // Maximum distance in kilometers
    final locationsRef = await placeRepository.fetchPlaces();
    nearestLocations.clear();
    for (final doc in locationsRef) {
      for (final addressN in doc.adresses) {
        debugPrint(' ${doc.name}');
        if (addressN.lat.isNotEmpty) {
          final double lat = double.parse(addressN.lat);
          final double lng = double.parse(addressN.lang);
          final double distance = calculateDistance(
              currentLocation.latitude, currentLocation.longitude, lat, lng);

          if (distance <= maxDistance) {
            debugPrint(
                'hello it place that near you  ${doc.name} distance : ${distance},id: ${doc.id} lang:${doc.adresses[0].lang} , lat:${doc.adresses[0].lat} ');
            doc.distance = (distance * 1000).round();
            nearestLocations.add(doc);
            debugPrint(' ${doc.distance}');
          }
        } else {
          debugPrint('hello it null ${doc.name}');
        }
      }
    }
    removeDuplicates();
    nearPlace();
    return nearestLocations.toList();
  }

  Future<void> refresh() async {
    await getNearestLocations();
  }

  List removeDuplicates() {
    Set<Place> uniqueData = Set<Place>.from(nearestLocations);
    nearestLocations = uniqueData.toList();
    nearestLocations.sort((a, b) => a.distance.compareTo(b.distance));
    return nearestLocations;
  }
}
