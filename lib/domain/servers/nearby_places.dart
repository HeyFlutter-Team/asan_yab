import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/models/place.dart';
import '../../data/repositoris/places_repo.dart';
import '../riverpod/screen/value_of_nearby_drop_Down_Button.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'nearby_places.g.dart';

@riverpod
class NearbyPlaces extends _$NearbyPlaces {
  final placeRepository = PlacesRepo();
  List<Place> nearestLocations = [];
  void nearPlace() => state = nearestLocations;
  @override
  List<Place> build() => [];

  double degreesToRadians(double degrees) => degrees * pi / 180.0;

  double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadius = 6371;
    final lat1Rad = degreesToRadians(lat1);
    final lon1Rad = degreesToRadians(lon1);
    final lat2Rad = degreesToRadians(lat2);
    final lon2Rad = degreesToRadians(lon2);

    final dLat = lat2Rad - lat1Rad;
    final dLon = lon2Rad - lon1Rad;

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  Future<List<Place>> getNearestLocations() async {
    Position? currentLocation;
    late bool servicePermission = false;
    late LocationPermission permission;

    Future<Position> getCurrentLocation() async {
      servicePermission = await Geolocator.isLocationServiceEnabled();
      if (!servicePermission) {
        debugPrint('servies disabled');
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      return await Geolocator.getCurrentPosition();
    }

    currentLocation = await getCurrentLocation();

    double maxDistance = ref.watch(valueOfDropButtonProvider);
    final locationsRef = await placeRepository.fetchPlaces();
    nearestLocations.clear();
    for (final doc in locationsRef) {
      for (final addressN in doc.addresses) {
        debugPrint(' ${doc.name}');
        if (addressN.lat.isNotEmpty) {
          final lat = double.parse(addressN.lat);
          final lng = double.parse(addressN.lang);
          final distance = calculateDistance(
              currentLocation.latitude, currentLocation.longitude, lat, lng);

          if (distance <= maxDistance) {
            doc.distance = (distance * 1000).round();
            nearestLocations.add(doc);
            debugPrint(' ${doc.distance}');
          }
        } else {
          // debugPrint('hello it null ${doc.name}');
        }
      }
    }
    removeDuplicates();
    nearPlace();
    return nearestLocations.toList();
  }

  Future<void> refresh() async => await getNearestLocations();

  List removeDuplicates() {
    final uniqueData = Set<Place>.from(nearestLocations);
    nearestLocations = uniqueData.toList();
    nearestLocations.sort((a, b) => a.distance.compareTo(b.distance));
    return nearestLocations;
  }
}
