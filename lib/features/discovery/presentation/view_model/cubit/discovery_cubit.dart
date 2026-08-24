import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

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
    emit(DiscoveryLoading());

    try {
      if (isManualLocation && currentLocation != null) {
        final cafes = await repository.getNearbyCafes(
          latitude: currentLocation!.latitude,
          longitude: currentLocation!.longitude,
        );
        allCafes = List<CafeEntity>.from(cafes);
        if (allCafes.isEmpty) {
          emit(DiscoveryEmpty());
          return;
        }

        emit(
          DiscoverySuccess(
            cafes: List<CafeEntity>.from(allCafes),
            currentLocation: currentLocation,
          ),
        );

        return;
      }

      final position = await locationService.getCurrentLocation();

      if (position == null) {
        emit(DiscoveryError('Unable to get your current location'));

        return;
      }

      currentLocation = LatLng(position.latitude, position.longitude);

      final cafes = await repository.getNearbyCafes(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      allCafes = List<CafeEntity>.from(cafes);

      if (allCafes.isEmpty) {
        emit(DiscoveryEmpty());
        return;
      }

      emit(
        DiscoverySuccess(
          cafes: List<CafeEntity>.from(allCafes),
          currentLocation: currentLocation,
        ),
      );
    } catch (e) {
      emit(DiscoveryError(e.toString()));
    }
  }

  Future<void> showAllCafes() async {
    if (allCafes.isNotEmpty) {
      emit(
        DiscoverySuccess(
          cafes: List<CafeEntity>.from(allCafes),
          currentLocation: currentLocation,
        ),
      );

      return;
    }
    await loadNearbyCafes();
  }

  Future<void> searchCafes({required String query}) async {
    final trueQuery = query.trim();

    if (trueQuery.isEmpty) {
      await showAllCafes();
      return;
    }

    emit(DiscoveryLoading());

    try {
      final cafes = await repository.searchCafes(
        query: trueQuery,
        latitude: currentLocation?.latitude,
        longitude: currentLocation?.longitude,
      );

      if (cafes.isEmpty) {
        emit(DiscoveryEmpty());
        return;
      }

      emit(DiscoverySuccess(cafes: cafes, currentLocation: currentLocation));
    } catch (e) {
      emit(DiscoveryError(e.toString()));
    }
  }

  Future<void> getCafesByCategory({required String category}) async {
    final normalized = category.trim().toLowerCase();

    if (normalized.isEmpty) {
      await showAllCafes();
      return;
    }

    if (isAllCategory(normalized)) {
      await showAllCafes();
      return;
    }
    if (allCafes.isEmpty) {
      await loadNearbyCafes();

      if (allCafes.isEmpty) {
        return;
      }
    }

    emit(DiscoveryLoading());

    try {
      final filtered = allCafes.where((cafe) {
        if (isOpenCategory(normalized)) {
          return cafe.isOpen;
        }

        if (isWifiCategory(normalized)) {
          return containsAttribute(cafe, [
            'wifi',
            'wi-fi',
            'wi fi',
            'واي فاي',
            'واى فاى',
            'واي فاي مجاني',
          ]);
        }

        if (isQuietCategory(normalized)) {
          return containsAttribute(cafe, [
            'quiet',
            'study',
            'studying',
            'هادئ',
            'مذاكرة',
            'للمذاكرة',
            'هادي',
          ]);
        }

        if (isSpecialtyCategory(normalized)) {
          return containsAttribute(cafe, [
            'specialty',
            'specialty coffee',
            'قهوة مختصة',
            'مختصة',
          ]);
        }

        return containsAttribute(cafe, [normalized]);
      }).toList();

      if (filtered.isEmpty) {
        emit(DiscoveryEmpty());
        return;
      }

      emit(DiscoverySuccess(cafes: filtered, currentLocation: currentLocation));
    } catch (e) {
      emit(DiscoveryError(e.toString()));
    }
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

      allCafes = List<CafeEntity>.from(cafes);

      if (allCafes.isEmpty) {
        emit(DiscoveryEmpty());
        return;
      }

      emit(
        DiscoverySuccess(
          cafes: List<CafeEntity>.from(allCafes),
          currentLocation: currentLocation,
        ),
      );
    } catch (e) {
      emit(DiscoveryError(e.toString()));
    }
  }

  bool isAllCategory(String category) {
    return category == 'الكل' ||
        category == 'all' ||
        category == 'كل الكافيهات';
  }

  bool isOpenCategory(String category) {
    return category == 'مفتوح الآن' ||
        category == 'open now' ||
        category == 'cafes open now';
  }

  bool isWifiCategory(String category) {
    return category == 'wi-fi' ||
        category == 'wifi' ||
        category == 'wi fi' ||
        category == 'واي فاي';
  }

  bool isQuietCategory(String category) {
    return category == 'هادئ للمذاكرة' ||
        category == 'quiet cafes for studying' ||
        category == 'quiet' ||
        category == 'study';
  }

  bool isSpecialtyCategory(String category) {
    return category == 'قهوة مختصة' ||
        category == 'specialty coffee' ||
        category == 'specialty';
  }

  bool containsAttribute(CafeEntity cafe, List<String> keywords) {
    final values =
        <String>[...cafe.attributes, cafe.name, cafe.description, cafe.address]
            .map((value) => value.toLowerCase().trim())
            .where((value) => value.isNotEmpty)
            .toList();

    for (final value in values) {
      for (final keyword in keywords) {
        if (value.contains(keyword.toLowerCase())) {
          return true;
        }
      }
    }

    return false;
  }
}
