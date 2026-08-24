import 'dart:math';

import 'package:latlong2/latlong.dart';

class KnownLocation {
  final String id;
  final String name;
  final LatLng center;
  final double radiusInMeters;

  const KnownLocation({
    required this.id,
    required this.name,
    required this.center,
    this.radiusInMeters = 12000,
  });

  bool contains(LatLng point) {
    return distanceMeters(center, point) <= radiusInMeters;
  }
}

const knownLocations = <KnownLocation>[
  KnownLocation(
    id: 'bagour_menoufia',
    name: 'المنوفية',
    center: LatLng(30.5586, 31.0116),
    radiusInMeters: 30000,
  ),

  KnownLocation(
    id: 'banha_qalyubia',
    name: 'بنها',
    center: LatLng(30.4667, 31.1848),
    radiusInMeters: 12000,
  ),

  KnownLocation(
    id: 'cairo',
    name: 'القاهرة',
    center: LatLng(30.0444, 31.2357),
    radiusInMeters: 16000,
  ),

  KnownLocation(
    id: 'giza',
    name: 'الجيزة',
    center: LatLng(30.0131, 31.2089),
    radiusInMeters: 14000,
  ),
];

KnownLocation? resolveKnownLocation(double latitude, double longitude) {
  final point = LatLng(latitude, longitude);

  if (isInsideMenoufia(latitude, longitude)) {
    return knownLocations.firstWhere(
      (location) => location.id == 'bagour_menoufia',
    );
  }

  final matches = knownLocations.where((location) {
    if (location.id == 'bagour_menoufia') {
      return false;
    }

    return location.contains(point);
  });

  if (matches.isEmpty) {
    return null;
  }

  return matches.reduce((a, b) {
    final distanceA = distanceMeters(a.center, point);

    final distanceB = distanceMeters(b.center, point);

    return distanceA <= distanceB ? a : b;
  });
}

bool isInsideMenoufia(double latitude, double longitude) {
  const minLatitude = 30.20;
  const maxLatitude = 30.75;

  const minLongitude = 30.70;
  const maxLongitude = 31.25;

  return latitude >= minLatitude &&
      latitude <= maxLatitude &&
      longitude >= minLongitude &&
      longitude <= maxLongitude;
}

double distanceMeters(LatLng a, LatLng b) {
  const earthRadius = 6371000.0;

  final dLat = toRadians(b.latitude - a.latitude);

  final dLon = toRadians(b.longitude - a.longitude);

  final x =
      sin(dLat / 2) * sin(dLat / 2) +
      cos(toRadians(a.latitude)) *
          cos(toRadians(b.latitude)) *
          sin(dLon / 2) *
          sin(dLon / 2);

  return earthRadius * 2 * atan2(sqrt(x), sqrt(1 - x));
}

double toRadians(double degrees) {
  return degrees * pi / 180;
}
