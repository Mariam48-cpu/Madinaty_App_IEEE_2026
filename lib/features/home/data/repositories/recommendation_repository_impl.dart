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
  static const double _homeRadiusKm = 2.0;
  static const double _homeRadiusMeters = 2000;

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
  // Distance validation
  // ============================================================

  bool _isInsideHomeRadius(double distanceKm) {
    if (distanceKm == double.infinity) {
      return false;
    }

    return distanceKm <= _homeRadiusKm;
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
    final List<CafeRecommendationEntity> allCafes = [];

    final firebaseImages = await _getFirebaseImages();

    // ==========================================================
    // 1. GPS موجود
    // ==========================================================

    if (userLocation != null) {
      try {
        // --------------------------------------------------------
        // Search by interests
        // --------------------------------------------------------

        if (interests.isNotEmpty) {
          for (final interest in interests) {
            try {
              final dtos = await placesDataSource.searchCafes(
                query: '$interest cafe',
                latitude: userLocation.latitude,
                longitude: userLocation.longitude,
                radiusMeters: _homeRadiusMeters,
              );

              for (final dto in dtos) {
                if (dto.id == null || dto.id!.isEmpty) {
                  continue;
                }

                final distanceKm = _calculateDistanceKm(
                  userLocation: userLocation,
                  cafe: dto,
                );

                // ------------------------------------------------
                // IMPORTANT:
                //
                // Google locationBias is NOT a strict radius.
                //
                // لذلك هنا نعمل فلترة حقيقية.
                // أي مكان أبعد من 2 KM يتم تجاهله.
                // ------------------------------------------------

                if (!_isInsideHomeRadius(distanceKm)) {
                  continue;
                }

                String imageUrl = '';

                if (firebaseImages.isNotEmpty) {
                  imageUrl =
                      firebaseImages[allCafes.length % firebaseImages.length];
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
                    moods: [
                      if (mood != null && mood.trim().isNotEmpty)
                        mood
                      else
                        AppLocale.quietChill,
                    ],
                    occasions: [
                      if (occasion != null && occasion.trim().isNotEmpty)
                        occasion
                      else
                        AppLocale.occasionOther,
                    ],
                    description: '${AppLocale.suitableForPrefix} $interest',
                    distanceKm: distanceKm,
                  ),
                );
              }
            } catch (_) {
              // لو interest معين فشل، نكمل باقي interests.
            }
          }
        }

        // ========================================================
        // 2. لو مفيش نتائج بالـ interests
        // ========================================================

        if (allCafes.isEmpty) {
          final dtos = await placesDataSource.getNearbyCafes(
            latitude: userLocation.latitude,
            longitude: userLocation.longitude,
            radiusMeters: _homeRadiusMeters,
          );

          for (int i = 0; i < dtos.length; i++) {
            final dto = dtos[i];

            if (dto.id == null || dto.id!.isEmpty) {
              continue;
            }

            final distanceKm = _calculateDistanceKm(
              userLocation: userLocation,
              cafe: dto,
            );

            // Strict 2 KM filtering.
            if (!_isInsideHomeRadius(distanceKm)) {
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
        }
      } catch (_) {
        // لو Google فشل والمستخدم عنده GPS،
        // نرجع للقائمة الفارغة بدل استخدام موقع القاهرة
        // كموقع للمستخدم.
      }
    }

    // ============================================================
    // 3. بدون GPS
    // ============================================================

    if (allCafes.isEmpty && userLocation == null) {
      if (interests.isNotEmpty) {
        for (final interest in interests) {
          try {
            final dtos = await placesDataSource.searchCafes(query: interest);

            for (final dto in dtos) {
              if (dto.id == null || dto.id!.isEmpty) {
                continue;
              }

              String imageUrl = '';

              if (firebaseImages.isNotEmpty) {
                imageUrl =
                    firebaseImages[allCafes.length % firebaseImages.length];
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
                  moods: [
                    if (mood != null && mood.trim().isNotEmpty)
                      mood
                    else
                      AppLocale.quietChill,
                  ],
                  occasions: [
                    if (occasion != null && occasion.trim().isNotEmpty)
                      occasion
                    else
                      AppLocale.occasionOther,
                  ],
                  description: '${AppLocale.suitableForPrefix} $interest',
                ),
              );
            }
          } catch (_) {
            // Continue with the next interest.
          }
        }
      }

      // ----------------------------------------------------------
      // Last technical fallback:
      // Cairo only when there is NO GPS at all.
      // ----------------------------------------------------------

      if (allCafes.isEmpty) {
        try {
          final defaultDtos = await placesDataSource.getNearbyCafes(
            latitude: 30.0444,
            longitude: 31.2357,
            radiusMeters: _homeRadiusMeters,
          );

          for (int i = 0; i < defaultDtos.length; i++) {
            final dto = defaultDtos[i];

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

            allCafes.add(
              _createCafeEntity(
                dto: dto,
                imageUrl: imageUrl,
                location: location,
                interests: [AppLocale.specialtyCoffee],
                moods: [mood ?? AppLocale.quietChill],
                occasions: [occasion ?? AppLocale.occasionOther],
                description: AppLocale.nearbyRecommendation,
              ),
            );
          }
        } catch (e) {
          throw Exception('${AppLocale.failedToLoadCafesError}: $e');
        }
      }
    }

    // ============================================================
    // Remove duplicates
    // ============================================================

    final uniqueCafes = <String, CafeRecommendationEntity>{};

    for (final cafe in allCafes) {
      if (cafe.id.isEmpty) {
        continue;
      }

      if (!uniqueCafes.containsKey(cafe.id)) {
        uniqueCafes[cafe.id] = cafe;
        continue;
      }

      final existing = uniqueCafes[cafe.id]!;

      final mergedInterests = [
        ...existing.interests,
        ...cafe.interests,
      ].toSet().toList();

      final mergedMoods = [...existing.moods, ...cafe.moods].toSet().toList();

      final mergedOccasions = [
        ...existing.occasions,
        ...cafe.occasions,
      ].toSet().toList();

      final nearestDistance = math.min(existing.distanceKm, cafe.distanceKm);

      uniqueCafes[cafe.id] = CafeRecommendationEntity(
        id: existing.id,
        name: existing.name,
        imageUrl: existing.imageUrl.isNotEmpty
            ? existing.imageUrl
            : cafe.imageUrl,
        rating: existing.rating > 0 ? existing.rating : cafe.rating,
        reviewsCount: existing.reviewsCount > 0
            ? existing.reviewsCount
            : cafe.reviewsCount,
        distanceKm: nearestDistance,
        location: existing.location.isNotEmpty
            ? existing.location
            : cafe.location,
        description: existing.description,
        interests: mergedInterests,
        moods: mergedMoods,
        occasions: mergedOccasions,
        latitude: existing.latitude ?? cafe.latitude,
        longitude: existing.longitude ?? cafe.longitude,
      );
    }

    final results = uniqueCafes.values.toList();

    // ============================================================
    // Sort by distance
    // ============================================================

    if (userLocation != null) {
      results.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    }

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
