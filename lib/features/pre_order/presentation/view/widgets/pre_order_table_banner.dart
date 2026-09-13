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

  String _getDisplayCafeName(BuildContext context) {
    if (cafe?.name != null && cafe!.name.isNotEmpty) {
      return cafe!.name;
    }

    if (booking?.cafeName != null && booking!.cafeName!.isNotEmpty) {
      return booking!.cafeName!;
    }

    if (cafeName != null && cafeName!.isNotEmpty) {
      return cafeName!;
    }

    return AppLocale.cafeLabel.getString(context);
  }

  String _getDisplayCafeAddress(BuildContext context) {
    if (cafe?.address != null && cafe!.address.isNotEmpty) {
      return cafe!.address;
    }

    if (booking?.cafeLocation != null &&
        booking!.cafeLocation!.isNotEmpty) {
      return booking!.cafeLocation!;
    }

    return AppLocale.locationNotSpecified.getString(context);
  }

  String? _getCafeImage() {
    if (cafe == null || cafe!.photos.isEmpty) {
      return null;
    }

    final image = cafe!.photos.first.trim();

    return image.isNotEmpty ? image : null;
  }

  @override
  Widget build(BuildContext context) {
    final displayCafeName = _getDisplayCafeName(context);
    final displayCafeAddress = _getDisplayCafeAddress(context);
    final cafeImage = _getCafeImage();

    final table = booking?.seatingPreference ?? 'T3';
    final time = booking?.time ?? '--:--';
    final guests = booking?.guests ?? 1;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
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
          // CAFE IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 52,
              height: 52,
              child: cafeImage != null
                  ? Image.network(
                      cafeImage,
                      fit: BoxFit.cover,
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return _buildImagePlaceholder();
                      },
                    )
                  : _buildImagePlaceholder(),
            ),
          ),

          const SizedBox(width: 11),

          // CAFE INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  displayCafeName,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 2),

                Text(
                  displayCafeAddress,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 10.5,
                    color: AppColors.textSecondary,
                    height: 1.25,
                  ),
                  maxLines: 2,
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

                    const Text(
                      ' • ',
                      style: TextStyle(
                        color: AppColors.divider,
                      ),
                    ),

                    Text(
                      time,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const Text(
                      ' • ',
                      style: TextStyle(
                        color: AppColors.divider,
                      ),
                    ),

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

  Widget _buildImagePlaceholder() {
    return Container(
      color: const Color(0xFFF5EBE6),
      child: const Center(
        child: Icon(
          Icons.local_cafe_rounded,
          color: Color(0xFFC07343),
          size: 23,
        ),
      ),
    );
  }
}
