import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

class CategoryResultLocation extends StatelessWidget {
  final CafeEntity cafe;
  final LatLng? userLocation;

  const CategoryResultLocation({
    super.key,
    required this.cafe,
    required this.userLocation,
  });

  String getDistance() {
    if (userLocation == null) {
      return '';
    }

    final distance =  Distance().as(
      LengthUnit.Kilometer,
      userLocation!,
      cafe.location,
    );
    if (distance < 1) {
      final meters = (distance * 1000).round();
      return '$meters م';
    }
    return '${distance.toStringAsFixed(1)} كم';
  }

  @override
  Widget build(BuildContext context) {
    final distance = getDistance();
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (distance.isNotEmpty) ...[
          Text(
            distance,
            style:  TextStyle(fontSize: 11, color: Colors.grey),
          ),
           SizedBox(width: 5),
           Text('•', style: TextStyle(fontSize: 11, color: Colors.grey)),
           SizedBox(width: 5),
        ],
        Flexible(
          child: Text(
            cafe.address.isNotEmpty ? cafe.address : 'الموقع غير متاح',
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:  TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ),
         SizedBox(width: 4),
         Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
      ],
    );
  }
}
