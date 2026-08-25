import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:latlong2/latlong.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

class CategoryResultLocation extends StatelessWidget {
  final CafeEntity cafe;
  final LatLng? userLocation;

  const CategoryResultLocation({
    super.key,
    required this.cafe,
    required this.userLocation,
  });

  String getDistance(BuildContext context) {
    if (userLocation == null) {
      return '';
    }

    final distance = const Distance().as(
      LengthUnit.Kilometer,
      userLocation!,
      cafe.location,
    );
    if (distance < 1) {
      final meters = (distance * 1000).round();
      return '$meters ${AppLocale.metersUnit.getString(context)}';
    }
    return '${distance.toStringAsFixed(1)} ${AppLocale.distanceKm.getString(context)}';
  }

  @override
  Widget build(BuildContext context) {
    final distance = getDistance(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (distance.isNotEmpty) ...[
          Text(
            distance,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 5),
          const Text(
            '•',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 5),
        ],
        Flexible(
          child: Text(
            cafe.address.isNotEmpty
                ? cafe.address
                : AppLocale.defaultCafeLocation.getString(context),
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 4),
        const Icon(
          Icons.location_on_outlined,
          size: 14,
          color: AppColors.textSecondary,
        ),
      ],
    );
  }
}