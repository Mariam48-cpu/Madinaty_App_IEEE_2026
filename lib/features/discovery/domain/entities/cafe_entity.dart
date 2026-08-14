import 'package:latlong2/latlong.dart';
class CafeEntity {
  final String id;
  final String name;
  final LatLng location;
  final double rating;
  final List<String> photos;
  final String address;
  final bool isOpen;

  const CafeEntity({
    this.id = '',
    this.name = '',
    required this.location,
    this.rating = 0.0,
    this.photos = const [],
    this.address = '',
    this.isOpen = false,
  });
}