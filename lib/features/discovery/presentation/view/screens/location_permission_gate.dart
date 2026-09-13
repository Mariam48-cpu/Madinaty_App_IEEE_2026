import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:madinaty_app_ieee_2026/core/di/injection_container.dart';
import 'package:madinaty_app_ieee_2026/core/services/location_service.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/screens/explore_map_screen.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/screens/map_picker_screen.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view_model/cubit/discovery_cubit.dart';

import 'location_permission_screen.dart';

class LocationPermissionGate extends StatefulWidget {
  const LocationPermissionGate({super.key});

  @override
  State<LocationPermissionGate> createState() =>
      _LocationPermissionGateState();
}

class _LocationPermissionGateState extends State<LocationPermissionGate> {
  final LocationService locationService = sl<LocationService>();

  static bool _permissionGateShown = false;
  bool _openMap = false;

  @override
  void initState() {
    super.initState();

    if (_permissionGateShown) {
      _openMap = true;
    } else {
      _permissionGateShown = true;
    }
  }

  void openExploreMap() {
    if (!mounted) return;

    setState(() {
      _openMap = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_openMap) {
      return ExploreMapScreen(
        cubit: sl<DiscoveryCubit>(),
      );
    }

    return LocationPermissionScreen(
      locationService: locationService,
      onPermissionGranted: openExploreMap,
      onChooseManually: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MapPickerScreen(
              onLocationSelected: (LatLng selectedLocation) {
                openExploreMap();
              },
            ),
          ),
        );
      },
    );
  }
}