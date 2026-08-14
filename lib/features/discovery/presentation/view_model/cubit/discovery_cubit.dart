// presentation/view_model/cubit/discovery_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

import 'package:madinaty_app_ieee_2026/core/services/location_service.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/repositories/cafe_repository_interface.dart';
import 'discovery_state.dart';

@injectable
class DiscoveryCubit extends Cubit<DiscoveryState> {
  final CafeRepositoryInterface repository;
  final LocationService locationService;

  LatLng? _cachedLocation;

  DiscoveryCubit({required this.repository, required this.locationService})
    : super(const DiscoveryInitial());

  Future<void> loadNearbyCafes() async {
    emit(const DiscoveryLoading());

    try {
      final position = await locationService.getCurrentLocation();

      if (position == null) {
        emit(const DiscoveryError('Location permission was denied.'));
        return;
      }

      _cachedLocation = LatLng(position.latitude, position.longitude);

      final cafes = await repository.getNearbyCafes(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      if (cafes.isEmpty) {
        emit(const DiscoveryEmpty());
        return;
      }

      emit(DiscoverySuccess(cafes, _cachedLocation));
    } catch (e) {
      emit(DiscoveryError(e.toString()));
    }
  }

  Future<void> searchCafes({required String query}) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return;

    emit(const DiscoveryLoading());

    try {
      final cafes = await repository.searchCafes(query: cleanQuery);

      if (cafes.isEmpty) {
        emit(const DiscoveryEmpty());
        return;
      }

      emit(DiscoverySuccess(cafes, _cachedLocation));
    } catch (e) {
      emit(DiscoveryError(e.toString()));
    }
  }

  Future<void> getCafesByCategory({required String category}) async {
    emit(const DiscoveryLoading());

    try {
      final cafes = await repository.getCafesByCategory(category: category);

      if (cafes.isEmpty) {
        emit(const DiscoveryEmpty());
        return;
      }

      emit(DiscoverySuccess(cafes, _cachedLocation));
    } catch (e) {
      emit(DiscoveryError(e.toString()));
    }
  }

  void resetSearch() {
    emit(const DiscoveryInitial());
  }
}
