import 'package:latlong2/latlong.dart';

import '../entities/cafe_recommendation_entity.dart';

abstract class RecommendationRepository {
  Future<List<CafeRecommendationEntity>> getPersonalizedRecommendations({
    required List<String> interests,
    required String? mood,
    required String? occasion,
    required String location,
    LatLng? userLocation,
  });

  Future<List<CafeRecommendationEntity>> searchCafes(String query);
}
