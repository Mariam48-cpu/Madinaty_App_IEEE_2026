import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

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
    } catch (_) {}

    return images;
  }

  String _getGoogleImageUrl(CafeDto dto) {
    final photoName = dto.firstPhotoName;

    if (photoName == null || photoName.trim().isEmpty) {
      return '';
    }

    return placesDataSource.getPhotoUrl(photoName);
  }

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
      name: dto.displayName ?? 'كافيه',
      imageUrl: imageUrl,
      rating: dto.rating ?? 0.0,
      reviewsCount: dto.userRatingCount ?? 0,
      distanceKm: distanceKm,
      location: dto.formattedAddress ?? location,
      description: description ?? 'كافيه مناسب لك',
      interests: interests?.isNotEmpty == true ? interests! : ['قهوة مختصة'],
      moods: moods?.isNotEmpty == true ? moods! : ['جلسة هادئة'],
      occasions: occasions?.isNotEmpty == true ? occasions! : ['عام'],
    );
  }

  @override
  Future<List<CafeRecommendationEntity>> getPersonalizedRecommendations({
    required List<String> interests,
    required String? mood,
    required String? occasion,
    required String location,
  }) async {
    final List<CafeRecommendationEntity> allCafes = [];

    final firebaseImages = await _getFirebaseImages();

    if (interests.isNotEmpty) {
      for (final interest in interests) {
        try {
          final List<CafeDto> dtos = await placesDataSource.searchCafes(
            query: interest,
          );

          for (int i = 0; i < dtos.length; i++) {
            final dto = dtos[i];

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
                    'جلسة هادئة',
                ],
                occasions: [
                  if (occasion != null && occasion.trim().isNotEmpty)
                    occasion
                  else
                    'عام',
                ],
                description: 'مناسب لـ $interest',
                distanceKm: 2.0,
              ),
            );
          }
        } catch (_) {}
      }
    }

    if (allCafes.isEmpty) {
      try {
        final List<CafeDto> defaultDtos = await placesDataSource.getNearbyCafes(
          latitude: 30.0444,
          longitude: 31.2357,
        );

        for (int i = 0; i < defaultDtos.length; i++) {
          final dto = defaultDtos[i];

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
              interests: ['قهوة مختصة'],
              moods: [mood ?? 'جلسة هادئة'],
              occasions: [occasion ?? 'عام'],
              description: 'مقترح قريب منك',
              distanceKm: 1.5,
            ),
          );
        }
      } catch (e) {
        throw Exception('فشل في تحميل الكافيهات: $e');
      }
    }

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
        distanceKm: existing.distanceKm,
        location: existing.location.isNotEmpty
            ? existing.location
            : cafe.location,
        description: existing.description,
        interests: mergedInterests,
        moods: mergedMoods,
        occasions: mergedOccasions,
      );
    }

    return uniqueCafes.values.toList();
  }

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
            location: dto.formattedAddress ?? 'الموقع غير متوفر',
            interests: ['قهوة', 'قهوة مختصة'],
            moods: ['جلسة هادئة'],
            occasions: ['عام'],
            description: 'نتيجة بحث عن "$searchQuery"',
          ),
        );
      }

      final Map<String, CafeRecommendationEntity> uniqueResults = {};

      for (final cafe in results) {
        if (cafe.id.isNotEmpty) {
          uniqueResults[cafe.id] = cafe;
        }
      }

      return uniqueResults.values.toList();
    } catch (e) {
      throw Exception('فشل في البحث عن الكافيهات: $e');
    }
  }
}
