import 'package:injectable/injectable.dart';

import 'package:madinaty_app_ieee_2026/features/cafe/data/data_sources/cafe_firestore_data_source.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/cafe_experience_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/menu_category_entity.dart';

import 'package:madinaty_app_ieee_2026/features/discovery/data/data_sources/google_places_datasource.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/data/models/known_location.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/repositories/cafe_repository_interface.dart';

@Injectable(as: CafeRepositoryInterface)
class CafeRepositoryImpl implements CafeRepositoryInterface {
  static const int targetCafeCount = 30;

  final GooglePlacesDataSource googlePlacesDataSource;
  final CafeFirestoreDataSource firebaseDataSource;

  CafeRepositoryImpl({
    required this.googlePlacesDataSource,
    required this.firebaseDataSource,
  });

  @override
  Future<List<CafeEntity>> getNearbyCafes({
    required double latitude,
    required double longitude,
  }) async {
    final knownLocation = resolveKnownLocation(latitude, longitude);

    if (knownLocation != null) {
      final cafes = await firebaseDataSource.getOrSeedLocationCafes(
        locationId: knownLocation.id,
        locationName: knownLocation.name,
        latitude: latitude,
        longitude: longitude,
        radiusInMeters: knownLocation.radiusInMeters,
      );
      if (cafes.isNotEmpty) {
        return cafes;
      }

      final storedLocationId = await firebaseDataSource
          .findNearestStoredLocationId(
            latitude: latitude,
            longitude: longitude,
          );

      if (storedLocationId != null) {
        final storedCafes = await firebaseDataSource.getLocationCafes(
          storedLocationId,
        );

        if (storedCafes.isNotEmpty) {
          return storedCafes;
        }
      }

      return cafes;
    }

    final storedLocationId = await firebaseDataSource
        .findNearestStoredLocationId(latitude: latitude, longitude: longitude);

    if (storedLocationId != null) {
      final storedCafes = await firebaseDataSource.getLocationCafes(
        storedLocationId,
      );

      if (storedCafes.isNotEmpty) {
        return storedCafes;
      }
    }

    return getDynamicLocation(latitude: latitude, longitude: longitude);
  }

  Future<List<CafeEntity>> getDynamicLocation({
    required double latitude,
    required double longitude,
  }) async {
    final locationId = dynamicLocationId(latitude, longitude);

    final cached = await firebaseDataSource.getLocationCafes(locationId);

    if (cached.length >= targetCafeCount) {
      return cached;
    }

    final googleCafes = await googlePlacesDataSource.getCafesForLocation(
      latitude: latitude,
      longitude: longitude,
      radiusInMeters: 12000,
      targetCount: targetCafeCount,
    );

    final entities = googleCafes
        .map((dto) => dto.toEntity())
        .toList(growable: false);
    if (entities.isEmpty) {
      return cached;
    }

    await firebaseDataSource.saveCafesForLocation(
      locationId: locationId,
      locationName: 'منطقة جديدة',
      latitude: latitude,
      longitude: longitude,
      cafes: entities,
    );

    return entities;
  }

  @override
  Future<List<CafeEntity>> searchCafes({
    required String query,
    double? latitude,
    double? longitude,
  }) async {
    final q = query.trim();

    if (q.isEmpty) {
      return [];
    }

    if (latitude != null && longitude != null) {
      final knownLocation = resolveKnownLocation(latitude, longitude);

      if (knownLocation != null) {
        await firebaseDataSource.getOrSeedLocationCafes(
          locationId: knownLocation.id,
          locationName: knownLocation.name,
          latitude: latitude,
          longitude: longitude,
          radiusInMeters: knownLocation.radiusInMeters,
        );

        return firebaseDataSource.searchLocationCafes(
          locationId: knownLocation.id,
          query: q,
        );
      }

      final storedLocationId = await firebaseDataSource
          .findNearestStoredLocationId(
            latitude: latitude,
            longitude: longitude,
          );

      if (storedLocationId != null) {
        return firebaseDataSource.searchLocationCafes(
          locationId: storedLocationId,
          query: q,
        );
      }
    }

    final searchLatitude = latitude ?? 30.0444;

    final searchLongitude = longitude ?? 31.2357;

    final googleCafes = await googlePlacesDataSource.searchCafesNearLocation(
      query: q,
      latitude: searchLatitude,
      longitude: searchLongitude,
      radiusInMeters: 12000,
    );

    final results = googleCafes
        .map((dto) => dto.toEntity())
        .toList(growable: false);

    if (latitude != null && longitude != null && results.isNotEmpty) {
      await firebaseDataSource.saveCafesForLocation(
        locationId: dynamicLocationId(latitude, longitude),
        locationName: 'منطقة جديدة',
        latitude: latitude,
        longitude: longitude,
        cafes: results,
      );
    }

    return results;
  }

  @override
  Future<List<CafeEntity>> getCafesByCategory({
    required String category,
    double? latitude,
    double? longitude,
  }) {
    return searchCafes(
      query: category,
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  Future<List<String>> getRandomCafePhotos() async {
    return const [];
  }

  @override
  Future<CafeExperienceEntity> getCafeExperience(CafeEntity cafe) {
    return firebaseDataSource.getCafeExperience(cafe);
  }

  @override
  Future<List<MenuCategoryEntity>> getCafeMenu(String cafeId) {
    return firebaseDataSource.getCafeMenu(cafeId);
  }

  String dynamicLocationId(double latitude, double longitude) {
    final latBucket = (latitude * 100).round();

    final lonBucket = (longitude * 100).round();

    return 'dynamic_${latBucket}_$lonBucket';
  }
}
