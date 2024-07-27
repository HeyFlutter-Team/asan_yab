import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../data/models/place.dart';
import '../../data/repositoris/places_rep.dart';
import '../riverpod/screen/drop_Down_Buton.dart';

final nearbyPlace = StateNotifierProvider<NearbyPlace, List<Place>>(
      (ref) => NearbyPlace([], ref),
);

class NearbyPlace extends StateNotifier<List<Place>> {
  final Ref ref;
  final PlacesRepository placeRepository = PlacesRepository();
  List<Place> nearestLocations = [];

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

  Future<Position> getCurrentLocation() async {
    bool servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      }
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<List<Place>> getNearestLocations(WidgetRef ref) async {
    Position currentLocation;
    try {
      currentLocation = await getCurrentLocation();
    } catch (e) {
      debugPrint('Error getting current location: $e');
      return [];
    }

    double maxDistance = ref.watch(valueOfDropButtonProvider); // Maximum distance in kilometers
    List<Place> locationsRef;
    try {
      locationsRef = await placeRepository.fetchPlaces();
    } catch (e) {
      debugPrint('Error fetching places: $e');
      return [];
    }

    nearestLocations.clear();
    for (final doc in locationsRef) {
      for (final address in doc.addresses) {
        if (address.latLng != null) {
          final double lat = address.latLng!.latitude;
          final double lng = address.latLng!.longitude;
          final double distance = calculateDistance(
            currentLocation.latitude,
            currentLocation.longitude,
            lat,
            lng,
          );

          if (distance <= maxDistance) {
            doc.distance = (distance * 1000).round();
            nearestLocations.add(doc);
            debugPrint(' ${doc.distance}');
          }
        }
      }
    }

    return nearestLocations.toSet().toList(); // Remove duplicates
  }

  Future<void> refresh(WidgetRef ref) async {
    try {
      nearestLocations = await getNearestLocations(ref);
      state = nearestLocations;
    } catch (e) {
      debugPrint('Error refreshing locations: $e');
    }
  }

  void nearPlace() {
    state = nearestLocations;
  }

  List<Place> removeDuplicates() {
    Set<Place> uniqueData = Set<Place>.from(nearestLocations);
    nearestLocations = uniqueData.toList();
    nearestLocations.sort((a, b) => a.distance.compareTo(b.distance));
    return nearestLocations;
  }
}
