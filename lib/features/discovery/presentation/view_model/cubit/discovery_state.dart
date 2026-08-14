import 'package:latlong2/latlong.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

abstract class DiscoveryState {
  const DiscoveryState();
}

class DiscoveryInitial extends DiscoveryState {
  const DiscoveryInitial();
}

class DiscoveryLoading extends DiscoveryState {
  const DiscoveryLoading();
}

class DiscoverySuccess extends DiscoveryState {
  final List<CafeEntity> cafes;
  final LatLng? currentLocation;

  const DiscoverySuccess({required this.cafes, this.currentLocation});
}

class DiscoveryEmpty extends DiscoveryState {
  const DiscoveryEmpty();
}

class DiscoveryError extends DiscoveryState {
  final String message;

  const DiscoveryError(this.message);
}
