import 'package:latlong2/latlong.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

abstract class DiscoveryState {
  DiscoveryState();
}

class DiscoveryInitial extends DiscoveryState {
  DiscoveryInitial();
}

class DiscoveryLoading extends DiscoveryState {
  DiscoveryLoading();
}

class DiscoverySuccess extends DiscoveryState {
  final List<CafeEntity> cafes;
  final LatLng? currentLocation;

  DiscoverySuccess({required this.cafes, this.currentLocation});
}

class DiscoveryEmpty extends DiscoveryState {
  DiscoveryEmpty();
}

class DiscoveryError extends DiscoveryState {
  final String message;

  DiscoveryError(this.message);
}
