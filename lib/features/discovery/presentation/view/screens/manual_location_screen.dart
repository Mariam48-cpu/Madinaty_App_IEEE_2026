import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/utils/app_toast.dart';
import 'package:toastification/toastification.dart';

class ManualLocationScreen extends StatefulWidget {
  final Function(LatLng selectedLocation) onLocationSelected;

  const ManualLocationScreen({super.key, required this.onLocationSelected});

  @override
  State<ManualLocationScreen> createState() => _ManualLocationScreenState();
}

class _ManualLocationScreenState extends State<ManualLocationScreen> {
  final MapController mapController = MapController();
  LatLng currentSelectedLocation = const LatLng(30.0444, 31.2357);
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getCurrentGPSLocation();
  }

  Future<void> _getCurrentGPSLocation() async {
    setState(() => isLoading = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          AppToast.showToast(
            context: context,
            title: AppLocale.toastError.getString(context),
            description: AppLocale.enableGpsPrompt.getString(context),
            type: ToastificationType.warning,
          );
        }
        setState(() => isLoading = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => isLoading = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => isLoading = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final userLatLng = LatLng(position.latitude, position.longitude);

      setState(() {
        currentSelectedLocation = userLatLng;
        isLoading = false;
      });

      mapController.move(userLatLng, 15);
    } catch (e) {
      debugPrint('Error getting GPS location: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppLocale.selectLocationTitle.getString(context),
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: currentSelectedLocation,
              initialZoom: 14.0,
              onTap: (tapPosition, point) {
                setState(() {
                  currentSelectedLocation = point;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'madinaty_app_ieee_2026',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: currentSelectedLocation,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_on,
                      color: AppColors.primary,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton.small(
              backgroundColor: AppColors.primary,
              onPressed: _getCurrentGPSLocation,
              child: const Icon(Icons.my_location, color: AppColors.textWhite),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkButton,
                foregroundColor: AppColors.onDarkButton,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                widget.onLocationSelected(currentSelectedLocation);
                Navigator.pop(context);
              },
              child: Text(
                AppLocale.confirmSelectedLocation.getString(context),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onDarkButton,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}