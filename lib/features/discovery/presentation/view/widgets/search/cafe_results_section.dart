import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

import 'cafe_card.dart';

class CafeResultsSection extends StatelessWidget {
  final List<CafeEntity> cafes;
  final String query;

  const CafeResultsSection({
    super.key,
    required this.cafes,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    final displayedCafes = cafes.take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${cafes.length} ${AppLocale.resultsCountSuffix.getString(context)}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            Text(
              query.isEmpty
                  ? AppLocale.popularNowInYourArea.getString(context)
                  : '${AppLocale.resultsForPrefix.getString(context)} "$query"',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (displayedCafes.isEmpty)
          SizedBox(
            height: 80,
            child: Center(
              child: Text(
                AppLocale.noNearbyCafesFound.getString(context),
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
          )
        else
          SizedBox(
            height: 225,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: displayedCafes.length,
              itemBuilder: (_, index) {
                return CafeCard(cafe: displayedCafes[index]);
              },
            ),
          ),
      ],
    );
  }
}