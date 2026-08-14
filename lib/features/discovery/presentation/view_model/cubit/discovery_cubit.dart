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
    : super(const DiscoveryInitial());

  List<CafeEntity> allCafes = [];

  LatLng? currentLocation;

  Future<void> loadNearbyCafes() async {
    emit(const DiscoveryLoading());

    try {
      final position = await locationService.getCurrentLocation();

      if (position == null) {
        emit(const DiscoveryError('Unable to get your current location'));
        return;
      }

      currentLocation = LatLng(position.latitude, position.longitude);

      final cafes = await repository.getNearbyCafes(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      allCafes = cafes;

      if (cafes.isEmpty) {
        emit(const DiscoveryEmpty());
        return;
      }

      emit(DiscoverySuccess(cafes: cafes, currentLocation: currentLocation));
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

    emit(const DiscoveryLoading());

    try {
      final cafes = await repository.searchCafes(query: trueQuery);

      allCafes = cafes;

      if (cafes.isEmpty) {
        emit(const DiscoveryEmpty());
        return;
      }

      emit(DiscoverySuccess(cafes: cafes, currentLocation: currentLocation));
    } catch (e) {
      emit(DiscoveryError(e.toString()));
    }
  }

  Future<void> getCafesByCategory({required String category}) async {
    final categories = category.trim();

    if (categories.isEmpty) {
      return;
    }

    emit(const DiscoveryLoading());

    try {
      final cafes = await repository.getCafesByCategory(category: categories);

      allCafes = cafes;

      if (cafes.isEmpty) {
        emit(const DiscoveryEmpty());
        return;
      }

      emit(DiscoverySuccess(cafes: cafes, currentLocation: currentLocation));
    } catch (e) {
      emit(DiscoveryError(e.toString()));
    }
  }
}
