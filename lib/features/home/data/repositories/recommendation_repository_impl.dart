import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';

import '../../domain/entities/cafe_recommendation_entity.dart';
import '../../domain/repositories/recommendation_repository.dart';
import '../data_sources/google_places_datasource.dart';
import '../models/cafe_dto.dart';

@LazySingleton(as: RecommendationRepository)
class RecommendationRepositoryImpl implements RecommendationRepository {
  final GooglePlacesDataSource placesDataSource;
  final FirebaseFirestore firestore;

  RecommendationRepositoryImpl(this.placesDataSource, this.firestore);

  Future<List<String>> _getFirebaseImages() async {
    final List<String> images = [];

    try {
      final snapshot = await firestore.collection('cafes').get();

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final photos = data['photos'];

        if (photos is List) {
          for (final photo in photos) {
            if (photo is String && photo.trim().isNotEmpty) {
              images.add(photo.trim());
            }
          }
        }
      }
    } catch (_) {
      // Firebase images are optional.
      // Google images will be used as fallback.
    }

    return images;
  }

  // ============================================================
  // Google Image
  // ============================================================

  String _getGoogleImageUrl(CafeDto dto) {
    final photoName = dto.firstPhotoName;

    if (photoName == null || photoName.trim().isEmpty) {
      return '';
    }

    try {
      return placesDataSource.getPhotoUrl(photoName);
    } catch (_) {
      return '';
    }
  }

  // ============================================================
  // Distance
  // ============================================================

  double _calculateDistanceKm({
    required LatLng userLocation,
    required CafeDto cafe,
  }) {
    if (!cafe.hasLocation) {
      return double.infinity;
    }

    const earthRadiusKm = 6371.0;

    final lat1 = userLocation.latitude * math.pi / 180;
    final lat2 = cafe.latitude! * math.pi / 180;

    final deltaLat = (cafe.latitude! - userLocation.latitude) * math.pi / 180;

    final deltaLon = (cafe.longitude! - userLocation.longitude) * math.pi / 180;

    final a =
        math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(deltaLon / 2) *
            math.sin(deltaLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadiusKm * c;
  }

  // ============================================================
  // Centralized Interest / Search Terms Mapper
  // ============================================================

  List<String> _getSearchQueriesForInterest(String interest) {
    final trimmed = interest.trim();
    const Map<String, List<String>> mapping = {
      'قهوة مختصة': ['specialty coffee', 'coffee shop'],
      'أماكن للمذاكرة': ['study cafe', 'quiet cafe', 'workspace cafe'],
      'جلسة هادئة': ['quiet cafe', 'cozy cafe'],
      'مناسبة خاصة': ['cozy cafe', 'restaurant cafe'],
      'أنا وإخوتي/أصدقائي': ['group cafe', 'lounge cafe'],
      'عمل / مذاكرة': ['study cafe', 'workspace cafe'],
      'work': ['workspace cafe', 'study cafe'],
      'study': ['study cafe'],
      'coffee': ['specialty coffee'],
    };

    if (mapping.containsKey(trimmed)) {
      return mapping[trimmed]!;
    }

    if (trimmed.toLowerCase().contains('cafe') ||
        trimmed.toLowerCase().contains('قهوة')) {
      return [trimmed];
    }

    return ['$trimmed cafe'];
  }

  // ============================================================
  // Ranking Score Calculation
  // ============================================================

  double _calculateRankScore({
    required CafeRecommendationEntity cafe,
    required List<String> userInterests,
    required String? mood,
    required String? occasion,
  }) {
    final d = cafe.distanceKm;
    if (d == double.infinity) return -1.0;

    // 1. Proximity Score (Max 100)
    double proximityScore;
    if (d <= 1.0) {
      proximityScore = 100.0;
    } else if (d <= 3.0) {
      proximityScore = 100.0 - (d - 1.0) * 20.0; // 3km -> 60.0
    } else if (d <= 5.0) {
      proximityScore = 60.0 - (d - 3.0) * 15.0; // 5km -> 30.0
    } else {
      proximityScore = math.max(0.0, 30.0 - (d - 5.0) * 4.0);
    }

    // 2. Personalization Relevance Score (Max ~40)
    double personalizationScore = 0.0;
    for (final interest in userInterests) {
      final normInterest = interest.trim().toLowerCase();
      for (final cafeInterest in cafe.interests) {
        final normCafeInterest = cafeInterest.trim().toLowerCase();
        if (normCafeInterest.contains(normInterest) ||
            normInterest.contains(normCafeInterest)) {
          personalizationScore += 15.0;
          break;
        }
      }
    }

    if (mood != null && mood.trim().isNotEmpty) {
      final normMood = mood.trim().toLowerCase();
      if (cafe.name.toLowerCase().contains(normMood) ||
          cafe.description.toLowerCase().contains(normMood)) {
        personalizationScore += 10.0;
      }
    }

    if (occasion != null && occasion.trim().isNotEmpty) {
      final normOcc = occasion.trim().toLowerCase();
      if (cafe.name.toLowerCase().contains(normOcc) ||
          cafe.description.toLowerCase().contains(normOcc)) {
        personalizationScore += 10.0;
      }
    }

    // 3. Quality & Rating Score (Max ~20)
    final qualityScore =
        (cafe.rating / 5.0) * 15.0 + math.min(cafe.reviewsCount / 100.0, 5.0);

    return proximityScore + personalizationScore + qualityScore;
  }

  // ============================================================
  // Create Entity
  // ============================================================

  CafeRecommendationEntity _createCafeEntity({
    required CafeDto dto,
    required String imageUrl,
    required String location,
    List<String>? interests,
    List<String>? moods,
    List<String>? occasions,
    String? description,
    double distanceKm = 0.0,
  }) {
    return CafeRecommendationEntity(
      id: dto.id ?? '',
      name: dto.displayName ?? AppLocale.defaultCafeName,
      imageUrl: imageUrl,
      rating: dto.rating ?? 0.0,
      reviewsCount: dto.userRatingCount ?? 0,
      distanceKm: distanceKm,
      location: dto.formattedAddress ?? location,
      description: description ?? AppLocale.suitableCafeForYou,
      interests: interests?.isNotEmpty == true
          ? interests!
          : [AppLocale.specialtyCoffee],
      moods: moods?.isNotEmpty == true ? moods! : [AppLocale.quietChill],
      occasions: occasions?.isNotEmpty == true
          ? occasions!
          : [AppLocale.occasionOther],
      latitude: dto.latitude,
      longitude: dto.longitude,
    );
  }

  // ============================================================
  // Personalized Recommendations
  // ============================================================

  @override
  Future<List<CafeRecommendationEntity>> getPersonalizedRecommendations({
    required List<String> interests,
    required String? mood,
    required String? occasion,
    required String location,
    LatLng? userLocation,
  }) async {
    // ------------------------------------------------------------
    // LOCATION IS MANDATORY. Return empty list if no GPS/location.
    // ------------------------------------------------------------
    if (userLocation == null) {
      return [];
    }

    final List<CafeRecommendationEntity> allCafes = [];
    final firebaseImages = await _getFirebaseImages();

    // Dynamic radius stages: 3 KM -> 5 KM -> 8 KM
    final radiusStagesMeters = [3000.0, 5000.0, 8000.0];

    for (final radiusMeters in radiusStagesMeters) {
      final radiusKm = radiusMeters / 1000.0;

      // 1. Search by personalized interests
      if (interests.isNotEmpty) {
        for (final interest in interests) {
          final queries = _getSearchQueriesForInterest(interest);

          for (final query in queries) {
            try {
              final dtos = await placesDataSource.searchCafes(
                query: query,
                latitude: userLocation.latitude,
                longitude: userLocation.longitude,
                radiusMeters: radiusMeters,
              );

              for (final dto in dtos) {
                if (dto.id == null || dto.id!.isEmpty) continue;

                final distanceKm = _calculateDistanceKm(
                  userLocation: userLocation,
                  cafe: dto,
                );

                if (distanceKm == double.infinity || distanceKm > radiusKm) {
                  continue;
                }

                String imageUrl = '';
                if (firebaseImages.isNotEmpty) {
                  imageUrl = firebaseImages[allCafes.length % firebaseImages.length];
                }
                if (imageUrl.isEmpty) {
                  imageUrl = _getGoogleImageUrl(dto);
                }

                allCafes.add(
                  _createCafeEntity(
                    dto: dto,
                    imageUrl: imageUrl,
                    location: location,
                    interests: [interest],
                    moods: [if (mood != null && mood.trim().isNotEmpty) mood else AppLocale.quietChill],
                    occasions: [if (occasion != null && occasion.trim().isNotEmpty) occasion else AppLocale.occasionOther],
                    description: '${AppLocale.suitableForPrefix} $interest',
                    distanceKm: distanceKm,
                  ),
                );
              }
            } catch (_) {
              // Ignore single query error and continue
            }
          }
        }
      }

      // 2. Fetch nearby cafes if interest search yielded too few results
      if (allCafes.length < 5) {
        try {
          final dtos = await placesDataSource.getNearbyCafes(
            latitude: userLocation.latitude,
            longitude: userLocation.longitude,
            radiusMeters: radiusMeters,
          );

          for (int i = 0; i < dtos.length; i++) {
            final dto = dtos[i];
            if (dto.id == null || dto.id!.isEmpty) continue;

            final distanceKm = _calculateDistanceKm(
              userLocation: userLocation,
              cafe: dto,
            );

            if (distanceKm == double.infinity || distanceKm > radiusKm) {
              continue;
            }

            String imageUrl = '';
            if (firebaseImages.isNotEmpty) {
              imageUrl = firebaseImages[i % firebaseImages.length];
            }
            if (imageUrl.isEmpty) {
              imageUrl = _getGoogleImageUrl(dto);
            }

            allCafes.add(
              _createCafeEntity(
                dto: dto,
                imageUrl: imageUrl,
                location: location,
                interests: [AppLocale.specialtyCoffee],
                moods: [mood ?? AppLocale.quietChill],
                occasions: [occasion ?? AppLocale.occasionOther],
                description: AppLocale.nearbyRecommendation,
                distanceKm: distanceKm,
              ),
            );
          }
        } catch (_) {}
      }

      // Stop expanding radius if we found enough cafes (>= 5)
      if (allCafes.length >= 5) {
        break;
      }
    }

    // Deduplicate cafes by ID
    final uniqueCafes = <String, CafeRecommendationEntity>{};
    for (final cafe in allCafes) {
      if (cafe.id.isEmpty) continue;

      if (!uniqueCafes.containsKey(cafe.id)) {
        uniqueCafes[cafe.id] = cafe;
        continue;
      }

      final existing = uniqueCafes[cafe.id]!;
      final mergedInterests = {...existing.interests, ...cafe.interests}.toList();
      final mergedMoods = {...existing.moods, ...cafe.moods}.toList();
      final mergedOccasions = {...existing.occasions, ...cafe.occasions}.toList();
      final nearestDistance = math.min(existing.distanceKm, cafe.distanceKm);

      uniqueCafes[cafe.id] = CafeRecommendationEntity(
        id: existing.id,
        name: existing.name,
        imageUrl: existing.imageUrl.isNotEmpty ? existing.imageUrl : cafe.imageUrl,
        rating: existing.rating > 0 ? existing.rating : cafe.rating,
        reviewsCount: existing.reviewsCount > 0 ? existing.reviewsCount : cafe.reviewsCount,
        distanceKm: nearestDistance,
        location: existing.location.isNotEmpty ? existing.location : cafe.location,
        description: existing.description,
        interests: mergedInterests,
        moods: mergedMoods,
        occasions: mergedOccasions,
        latitude: existing.latitude ?? cafe.latitude,
        longitude: existing.longitude ?? cafe.longitude,
      );
    }

    final results = uniqueCafes.values.toList();

    // Sort using weighted proximity-first ranking score
    results.sort((a, b) {
      final scoreA = _calculateRankScore(
        cafe: a,
        userInterests: interests,
        mood: mood,
        occasion: occasion,
      );
      final scoreB = _calculateRankScore(
        cafe: b,
        userInterests: interests,
        mood: mood,
        occasion: occasion,
      );
      return scoreB.compareTo(scoreA); // Descending order
    });

    return results;
  }

  // ============================================================
  // Search Cafes
  // ============================================================

  @override
  Future<List<CafeRecommendationEntity>> searchCafes(String query) async {
    final searchQuery = query.trim();

    if (searchQuery.isEmpty) {
      return [];
    }

    try {
      final List<CafeDto> dtos = await placesDataSource.searchCafes(
        query: searchQuery,
      );

      final firebaseImages = await _getFirebaseImages();

      final List<CafeRecommendationEntity> results = [];

      for (int i = 0; i < dtos.length; i++) {
        final dto = dtos[i];

        if (dto.id == null || dto.id!.isEmpty) {
          continue;
        }

        String imageUrl = '';

        if (firebaseImages.isNotEmpty) {
          imageUrl = firebaseImages[i % firebaseImages.length];
        }

        if (imageUrl.isEmpty) {
          imageUrl = _getGoogleImageUrl(dto);
        }

        results.add(
          _createCafeEntity(
            dto: dto,
            imageUrl: imageUrl,
            location: dto.formattedAddress ?? AppLocale.defaultCafeLocation,
            interests: [AppLocale.specialtyCoffee],
            moods: [AppLocale.quietChill],
            occasions: [AppLocale.occasionOther],
            description: '${AppLocale.searchResultForPrefix} "$searchQuery"',
          ),
        );
      }

      // ----------------------------------------------------------
      // Remove duplicates
      // ----------------------------------------------------------

      final Map<String, CafeRecommendationEntity> uniqueResults = {};

      for (final cafe in results) {
        if (cafe.id.isNotEmpty) {
          uniqueResults[cafe.id] = cafe;
        }
      }

      return uniqueResults.values.toList();
    } catch (e) {
      throw Exception('${AppLocale.failedToSearchCafesError}: $e');
    }
  }
}
