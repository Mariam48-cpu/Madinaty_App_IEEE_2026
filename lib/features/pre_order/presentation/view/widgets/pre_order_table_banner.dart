import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_typography.dart';
import 'package:madinaty_app_ieee_2026/features/booking/domain/entities/booking_entity.dart';

class PreOrderTableBanner extends StatelessWidget {
  final BookingEntity? booking;
  final String cafeName;
  final VoidCallback? onEdit;

  const PreOrderTableBanner({
    super.key,
    this.booking,
    required this.cafeName,
    this.onEdit,
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
    'ديسمبر'
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (onEdit != null)
            GestureDetector(
              onTap: onEdit,
              child: Text(
                AppLocale.edit.getString(context),
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            const SizedBox(width: 32),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  cafeName,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  _formatBookingInfo(context),
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF9EAE1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.chair_alt_rounded,
              color: Color(0xFFC07343),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
