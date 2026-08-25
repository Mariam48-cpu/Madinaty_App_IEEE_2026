import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_typography.dart';
import '../../../domain/entities/booking_entity.dart';

class PassStatusBadge extends StatelessWidget {
  final BookingStatus status;

  const PassStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig(context, status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            config.icon,
            size: 14,
            color: config.textColor,
          ),
          const SizedBox(width: 4),
          Text(
            config.label,
            style: AppTypography.labelSmall.copyWith(
              color: config.textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(BuildContext context, BookingStatus status) {
    switch (status) {
      case BookingStatus.approved:
        return _StatusConfig(
          label: AppLocale.statusConfirmed.getString(context),
          textColor: AppColors.primary,
          backgroundColor: AppColors.primaryContainer,
          icon: Icons.check_circle_rounded,
        );
      case BookingStatus.pending:
        return _StatusConfig(
          label: AppLocale.statusPending.getString(context),
          textColor: AppColors.textSecondary,
          backgroundColor: AppColors.surfaceVariant,
          icon: Icons.access_time_rounded,
        );
      case BookingStatus.rejected:
      case BookingStatus.cancelled:
        return _StatusConfig(
          label: AppLocale.statusCancelled.getString(context),
          textColor: AppColors.error,
          backgroundColor: AppColors.errorContainer,
          icon: Icons.cancel_rounded,
        );
    }
  }
}

class _StatusConfig {
  final String label;
  final Color textColor;
  final Color backgroundColor;
  final IconData icon;

  const _StatusConfig({
    required this.label,
    required this.textColor,
    required this.backgroundColor,
    required this.icon,
  });
}