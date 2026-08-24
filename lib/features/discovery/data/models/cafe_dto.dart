import 'package:latlong2/latlong.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

class CafeDto {
  final String id;
  final String name;
  final LatLng location;
  final double rating;
  final int reviewsCount;
  final List<String> photos;
  final String address;
  final bool isOpen;
  final String openingHours;

  const CafeDto({
    this.id = '',
    this.name = '',
    required this.location,
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.photos = const [],
    this.address = '',
    this.isOpen = false,
    this.openingHours = '',
  });

  factory CafeDto.fromJson(Map<String, dynamic> json) {
    final location = json['location'] as Map<String, dynamic>?;
    final openingHours = json['currentOpeningHours'] as Map<String, dynamic>?;
    const photos = <String>[];
    return CafeDto(
      id: json['id'] as String? ?? '',
      name:
          (json['displayName'] as Map<String, dynamic>?)?['text'] as String? ??
          '',
      location: LatLng(
        (location?['latitude'] ?? 0.0).toDouble(),
        (location?['longitude'] ?? 0.0).toDouble(),
      ),
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewsCount: (json['userRatingCount'] ?? 0).toInt(),
      photos: photos,
      address: json['formattedAddress'] as String? ?? '',
      isOpen: openingHours?['openNow'] as bool? ?? false,
      openingHours: extractOpeningHours(openingHours),
    );
  }

  static String extractOpeningHours(Map<String, dynamic>? openingHours) {
    final periods = openingHours?['weekdayDescriptions'];
    if (periods is List) {
      return periods.whereType<String>().join(' | ');
    }
    return '';
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
      description: '',
      reviewsCount: reviewsCount,
      openingHours: openingHours,
      attributes: const [],
    );
  }
}
