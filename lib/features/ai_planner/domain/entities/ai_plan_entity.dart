import 'package:latlong2/latlong.dart';

class AIPlanRequestEntity {
  final String message;
  final double budget;
  final int durationHours;
  final List<String> interests;
  final String? mood;
  final String? occasion;
  final double? latitude;
  final double? longitude;

  const AIPlanRequestEntity({
    required this.message,
    required this.budget,
    required this.durationHours,
    this.interests = const [],
    this.mood,
    this.occasion,
    this.latitude,
    this.longitude,
  });
}

class AIPlanActivityEntity {
  final String title;
  final String purpose;
  final String category;
  final List<String> requirements;
  final int durationMinutes;
  final AIPlanPlaceEntity? place;

  const AIPlanActivityEntity({
    required this.title,
    required this.purpose,
    required this.category,
    required this.requirements,
    required this.durationMinutes,
    this.place,
  });
}

class AIPlanPlaceEntity {
  final String id;
  final String name;
  final String address;
  final double rating;
  final int reviewsCount;
  final bool isOpen;
  final String openingHours;
  final List<String> attributes;
  final List<String> photos;
  final LatLng location;
  final double distanceMeters;
  final double estimatedCost;
  final int matchScore;
  final String reason;

  const AIPlanPlaceEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.reviewsCount,
    required this.isOpen,
    required this.openingHours,
    required this.attributes,
    required this.photos,
    required this.location,
    required this.distanceMeters,
    required this.estimatedCost,
    required this.matchScore,
    required this.reason,
  });
}

class AIPlanEntity {
  final String headline;
  final String summary;
  final double estimatedTotal;
  final double budget;
  final String weatherSummary;
  final List<AIPlanActivityEntity> activities;

  const AIPlanEntity({
    required this.headline,
    required this.summary,
    required this.estimatedTotal,
    required this.budget,
    required this.weatherSummary,
    required this.activities,
  });
}
