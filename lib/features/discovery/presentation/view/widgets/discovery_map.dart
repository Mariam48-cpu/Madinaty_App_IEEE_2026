import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/widgets/cafe_details_bottom_sheet.dart';

class DiscoveryMapWidget extends StatefulWidget {
  final LatLng userLocation;
  final List<CafeEntity> cafes;

  const DiscoveryMapWidget({
    super.key,
    required this.userLocation,
    required this.cafes,
    required MapController mapController,
    required LatLng location,
  });

  @override
  State<DiscoveryMapWidget> createState() => _DiscoveryMapWidgetState();
}

class _DiscoveryMapWidgetState extends State<DiscoveryMapWidget> {
  final MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final markers = widget.cafes.map((cafe) {
      return Marker(
        point: LatLng(cafe.location.latitude, cafe.location.longitude),
        width: 45,
        height: 45,
        child: GestureDetector(
          onTap: () => showCafeDetailsBottomSheet(context: context, cafe: cafe),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black87,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
            ),
            child: Icon(Icons.coffee, color: Colors.white, size: 22),
          ),
        ),
      );
    }).toList();

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: widget.userLocation,
        initialZoom: 14.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.madinaty_app_ieee_2026',
        ),
        MarkerLayer(markers: markers),
      ],
    );
  }
}
