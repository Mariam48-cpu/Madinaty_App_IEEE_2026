import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

abstract class DiscoveryState extends Equatable {
  const DiscoveryState();

  @override
  List<Object?> get props => [];
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

  const DiscoverySuccess(this.cafes, this.currentLocation);

  @override
  List<Object?> get props => [cafes, currentLocation];
}

class DiscoveryEmpty extends DiscoveryState {
  const DiscoveryEmpty();
}

class DiscoveryError extends DiscoveryState {
  final String message;

  const DiscoveryError(this.message);

  @override
  List<Object?> get props => [message];
}
