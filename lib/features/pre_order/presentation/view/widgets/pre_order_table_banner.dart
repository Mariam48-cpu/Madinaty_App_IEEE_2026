import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_typography.dart';
import 'package:madinaty_app_ieee_2026/features/booking/domain/entities/booking_entity.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

class PreOrderTableBanner extends StatelessWidget {
  final BookingEntity? booking;
  final String? cafeName;
  final CafeEntity? cafe;

  const PreOrderTableBanner({
    super.key,
    this.booking,
    this.cafeName,
    this.cafe,
  });

  @override
  Widget build(BuildContext context) {
    final String displayCafeName = (cafe?.name != null && cafe!.name.isNotEmpty)
        ? cafe!.name
        : (booking?.cafeName != null && booking!.cafeName!.isNotEmpty)
        ? booking!.cafeName!
        : (cafeName != null && cafeName!.isNotEmpty)
        ? cafeName!
        : AppLocale.cafeLabel.getString(context);

    final String displayCafeAddress = (cafe?.address != null && cafe!.address.isNotEmpty)
        ? cafe!.address
        : (booking?.cafeLocation != null && booking!.cafeLocation!.isNotEmpty)
        ? booking!.cafeLocation!
        : AppLocale.locationNotSpecified.getString(context);

    final String table = booking?.seatingPreference ?? 'T3';
    final String time = booking?.time ?? '--:--';
    final int guests = booking?.guests ?? 1;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.table_restaurant_outlined,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayCafeName,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  displayCafeAddress,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${AppLocale.seating.getString(context)}: $table',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(' • ', style: TextStyle(color: AppColors.divider)),
                    Text(
                      time,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Text(' • ', style: TextStyle(color: AppColors.divider)),
                    Text(
                      '$guests ${AppLocale.guestsSuffix.getString(context)}',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}