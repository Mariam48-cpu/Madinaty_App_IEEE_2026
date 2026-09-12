import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_typography.dart';
import 'package:madinaty_app_ieee_2026/features/booking/domain/entities/booking_entity.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

class PreOrderTableBanner extends StatelessWidget {
  final BookingEntity? booking;
  final String cafeName;
  final CafeEntity? cafe;

  const PreOrderTableBanner({
    super.key,
    this.booking,
    required this.cafeName,
    this.cafe,
  });

  static const _arabicMonths = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  String _formatBookingInfo(BuildContext context) {
    if (booking == null) {
      return 'حجز طاولة • صالة داخلية';
    }

    String dateStr = '20 أكتوبر';

    if (booking!.date != null) {
      final month = _arabicMonths[booking!.date!.month - 1];

      dateStr = '${booking!.date!.day} $month';
    }

    final timeStr = booking!.time ?? '7:30 مساءً';

    final guestsStr =
        '${booking!.guests} ${AppLocale.guestsCountText.getString(context)}';

    final seatingStr = booking!.seatingPreference ?? 'ركن هادئ';

    return '$dateStr • $timeStr • $guestsStr • $seatingStr';
  }

  String? _getCafeImage() {
    if (cafe == null) return null;

    if (cafe!.photos.isNotEmpty) {
      final image = cafe!.photos.first.trim();

      if (image.isNotEmpty) {
        return image;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cafeImage = _getCafeImage();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // ======================================================
          // CAFE IMAGE
          // ======================================================
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 52,
              height: 52,
              child: cafeImage != null
                  ? Image.network(
                      cafeImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildImagePlaceholder();
                      },
                    )
                  : _buildImagePlaceholder(),
            ),
          ),

          const SizedBox(width: 11),

          // ======================================================
          // CAFE INFO
          // ======================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  cafeName,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                Text(
                  _formatBookingInfo(context),
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 10.5,
                    color: AppColors.textSecondary,
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
