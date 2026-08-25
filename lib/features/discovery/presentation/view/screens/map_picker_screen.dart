import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:madinaty_app_ieee_2026/core/di/injection.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/screens/explore_map_screen.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view_model/cubit/discovery_cubit.dart';

class MapPickerScreen extends StatefulWidget {
  final LatLng initialCenter;
  final Function(LatLng selectedLocation) onLocationSelected;

  const MapPickerScreen({
    super.key,
    this.initialCenter = const LatLng(30.0910, 31.6250),
    required this.onLocationSelected,
  });

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng? tappedPosition;

  @override
  void initState() {
    super.initState();
    tappedPosition = widget.initialCenter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppLocale.selectLocationOnMap.getString(context),
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: widget.initialCenter,
              initialZoom: 15.0,
              onTap: (tapPosition, latLng) {
                setState(() {
                  tappedPosition = latLng;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'madinaty_app_ieee_2026',
              ),
              if (tappedPosition != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: tappedPosition!,
                      width: 50,
                      height: 50,
                      child: const Align(
                        alignment: Alignment.bottomCenter,
                        child: Icon(
                          Icons.location_on,
                          size: 50,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            bottom: 24,
            left: 20,
            right: 20,
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkButton,
                  foregroundColor: AppColors.onDarkButton,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () async {
                  if (tappedPosition != null) {
                    final cubit = getIt<DiscoveryCubit>();
                    await cubit.loadCafesByManualLocation(
                      latitude: tappedPosition!.latitude,
                      longitude: tappedPosition!.longitude,
                    );
                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExploreMapScreen(cubit: cubit),
                      ),
                          (route) => false,
                    );
                  }
                },
                child: Text(
                  AppLocale.confirmThisLocation.getString(context),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}