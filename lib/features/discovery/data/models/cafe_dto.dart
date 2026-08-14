import 'package:latlong2/latlong.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

class CafeDto {
  final String id;
  final String name;
  final LatLng location;
  final double rating;
  final List<String> photos;
  final String address;
  final bool isOpen;

  const CafeDto({
    this.id = '',
    this.name = '',
    required this.location,
    this.rating = 0.0,
    this.photos = const [],
    this.address = '',
    this.isOpen = false,
  });

  factory CafeDto.fromJson(Map<String, dynamic> json) {
    final location = json['location'] as Map<String, dynamic>?;

    return CafeDto(
      id: json['id'] ?? '',
      name: json['displayName']?['text'] ?? '',
      location: LatLng(
        (location?['latitude'] ?? 0.0).toDouble(),
        (location?['longitude'] ?? 0.0).toDouble(),
      ),
      rating: (json['rating'] ?? 0.0).toDouble(),
      photos: [],
      address: json['formattedAddress'] ?? '',
      isOpen: json['currentOpeningHours']?['openNow'] ?? false,
    );
  }

  CafeEntity toEntity() {
    return CafeEntity(
      id: id,
      name: name,
      location: location,
      rating: rating,
      photos: photos,
      address: address,
      isOpen: isOpen,
    );
  }
}
