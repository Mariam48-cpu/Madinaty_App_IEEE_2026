import 'package:latlong2/latlong.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

class CafeModel {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final double rating;
  final List<String> photos;
  final String address;
  final bool isOpen;
  final String description;
  final int reviewsCount;
  final String openingHours;
  final List<String> attributes;

  const CafeModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.photos,
    required this.address,
    required this.isOpen,
    required this.description,
    required this.reviewsCount,
    required this.openingHours,
    required this.attributes,
  });

  factory CafeModel.fromFirestore(
    String documentId,
    Map<String, dynamic> data,
  ) {
    return CafeModel(
      id: documentId,
      name: data['name'] ?? '',
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
      rating: (data['rating'] ?? 0.0).toDouble(),
      photos: List<String>.from(data['photos'] ?? []),
      address: data['address'] ?? '',
      isOpen: data['isOpen'] ?? false,
      description: data['description'] ?? '',
      reviewsCount: (data['reviewsCount'] ?? 0).toInt(),
      openingHours: data['openingHours'] ?? '',
      attributes: List<String>.from(data['attributes'] ?? []),
    );
  }

  CafeEntity toEntity() {
    return CafeEntity(
      id: id,
      name: name,
      location: LatLng(latitude, longitude),
      rating: rating,
      photos: photos,
      address: address,
      isOpen: isOpen,
      description: description,
      reviewsCount: reviewsCount,
      openingHours: openingHours,
      attributes: attributes,
    );
  }
}