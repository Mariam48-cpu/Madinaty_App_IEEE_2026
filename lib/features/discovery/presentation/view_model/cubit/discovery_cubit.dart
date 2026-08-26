import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/services/location_service.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/repositories/cafe_repository_interface.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view_model/cubit/discovery_state.dart';

@injectable
class DiscoveryCubit extends Cubit<DiscoveryState> {
  final CafeRepositoryInterface repository;
  final LocationService locationService;

  DiscoveryCubit({required this.repository, required this.locationService})
      : super(DiscoveryInitial());

  List<CafeEntity> allCafes = [];
  bool isManualLocation = false;
  LatLng? currentLocation;

  Future<Object> requestLocationPermission() async {
    try {
      final permission = await locationService.requestPermission();

      return permission;
    } catch (e) {
      emit(DiscoveryError(e.toString()));
      return false;
    }
  }

  Future<void> loadNearbyCafes() async {
    if (isManualLocation && currentLocation != null) {
      return;
    }
    emit(DiscoveryLoading());

    try {
      final position = await locationService.getCurrentLocation();

      if (position == null) {
        emit(DiscoveryError(AppLocale.locationError));
        return;
      }

      currentLocation = LatLng(position.latitude, position.longitude);

      final cafes = await repository.getNearbyCafes(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      final cafesWithPhotos = await addRandomPhotosToCafes(cafes);

      allCafes = cafesWithPhotos;

      if (cafesWithPhotos.isEmpty) {
        emit(DiscoveryEmpty());
        return;
      }

      emit(
        DiscoverySuccess(
          cafes: cafesWithPhotos,
          currentLocation: currentLocation,
        ),
      );
    } catch (e) {
      emit(DiscoveryError(e.toString()));
    }
  }

  Future<void> searchCafes({required String query}) async {
    final trueQuery = query.trim();

    if (trueQuery.isEmpty) {
      await loadNearbyCafes();
      return;
    }

    emit(DiscoveryLoading());

    try {
      final cafes = await repository.searchCafes(query: trueQuery);

      final cafesWithPhotos = await addRandomPhotosToCafes(cafes);

      allCafes = cafesWithPhotos;

      if (cafesWithPhotos.isEmpty) {
        emit(DiscoveryEmpty());
        return;
      }

      emit(
        DiscoverySuccess(
          cafes: cafesWithPhotos,
          currentLocation: currentLocation,
        ),
      );
    } catch (e) {
      emit(DiscoveryError(e.toString()));
    }
  }

  Future<void> getCafesByCategory({required String category}) async {
    final categories = category.trim();

    if (categories.isEmpty) {
      return;
    }

    emit(DiscoveryLoading());

    try {
      final cafes = await repository.getCafesByCategory(category: categories);

      final cafesWithPhotos = await addRandomPhotosToCafes(cafes);

      allCafes = cafesWithPhotos;

      if (cafesWithPhotos.isEmpty) {
        emit(DiscoveryEmpty());
        return;
      }

      emit(
        DiscoverySuccess(
          cafes: cafesWithPhotos,
          currentLocation: currentLocation,
        ),
      );
    } catch (e) {
      emit(DiscoveryError(e.toString()));
    }
  }

  Future<List<CafeEntity>> addRandomPhotosToCafes(
      List<CafeEntity> cafes,
      ) async {
    final photos = await repository.getRandomCafePhotos();

    if (photos.isEmpty) {
      return cafes;
    }

    final random = Random();

    return cafes.map((cafe) {
      final randomPhoto = photos[random.nextInt(photos.length)];

      return CafeEntity(
        id: cafe.id,
        name: cafe.name,
        location: cafe.location,
        rating: cafe.rating,
        photos: [randomPhoto],
        address: cafe.address,
        isOpen: cafe.isOpen,
        description: cafe.description,
        reviewsCount: cafe.reviewsCount,
        openingHours: cafe.openingHours,
        attributes: cafe.attributes,
      );
    }).toList();
  }

  Future<void> loadCafesByManualLocation({
    required double latitude,
    required double longitude,
  }) async {
    emit(DiscoveryLoading());

    try {
      isManualLocation = true;
      currentLocation = LatLng(latitude, longitude);

      final cafes = await repository.getNearbyCafes(
        latitude: latitude,
        longitude: longitude,
      );

      final cafesWithPhotos = await addRandomPhotosToCafes(cafes);
      allCafes = cafesWithPhotos;

      if (cafesWithPhotos.isEmpty) {
        emit(DiscoveryEmpty());
        return;
      }

      emit(
        DiscoverySuccess(
          cafes: cafesWithPhotos,
          currentLocation: currentLocation,
        ),
      );
    } catch (e) {
      emit(DiscoveryError(e.toString()));
    }
  }
}