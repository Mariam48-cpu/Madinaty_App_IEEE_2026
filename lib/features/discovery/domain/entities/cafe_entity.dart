import 'package:latlong2/latlong.dart';

class CafeEntity {
  final String id;
  final String name;
  final LatLng location;
  final double rating;
  final List<String> photos;
  final String address;
  final bool isOpen;

  // Task 9
  final String description;
  final int reviewsCount;
  final String openingHours;
  final List<String> attributes;

  const CafeEntity({
    this.id = '',
    this.name = '',
    required this.location,
    this.rating = 0.0,
    this.photos = const [],
    this.address = '',
    this.isOpen = false,

    // Task 9
    this.description = '',
    this.reviewsCount = 0,
    this.openingHours = '',
    this.attributes = const [],
  });
}
