import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/models/place.dart';
import '../../data/repositoris/places_rep.dart';

final nearbyPlace =
    StateNotifierProvider<NearbyPlace, List<Place>>((ref) => NearbyPlace([]));

class NearbyPlace extends StateNotifier<List<Place>> {
  final placeRepository = PlacesRepository();
  final List<Place> nearestLocations = [];
  void nearPlace() => state = nearestLocations;
  NearbyPlace(super.state);
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

    const double maxDistance = 0.8; // Maximum distance in kilometers
    final locationsRef = await placeRepository.fetchPlaces();

    for (var doc in locationsRef) {
      final double lat = double.parse(doc.adresses[0].lat);
      final double lng = double.parse(doc.adresses[0].lang);
      final double distance = calculateDistance(
          currentLocation.latitude, currentLocation.longitude, lat, lng);

      if (distance <= maxDistance) {
        nearestLocations.add(doc);
        nearPlace();
      }
    }

    return nearestLocations.take(5).toList();
  }

  Future<void> refresh() async {
    if (nearestLocations.isEmpty) {
      await getNearestLocations();
    } else {
      nearestLocations.clear();
    }

    nearPlace();
  }
}
