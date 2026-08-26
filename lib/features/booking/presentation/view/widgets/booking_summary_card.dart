import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';

class BookingSummaryCard extends StatelessWidget {
  final String table;
  final String? time;
  final int guests;
  final String? seatingAreaName;

  const BookingSummaryCard({
    super.key,
    required this.table,
    required this.time,
    required this.guests,
    this.seatingAreaName,
  });

  @override
  Widget build(BuildContext context) {
    final String resolvedSeating =
        seatingAreaName ?? AppLocale.filterNileView.getString(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocale.selectedStatusLabel.getString(context),
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${AppLocale.tablePrefix.getString(context)} $table',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              resolvedSeating,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$guests ${AppLocale.guestsCountText.getString(context)} • ${time ?? '--'}',
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}