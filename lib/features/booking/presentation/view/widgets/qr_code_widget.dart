import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_typography.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../domain/entities/booking_entity.dart';

class QrCodeWidget extends StatelessWidget {
  final BookingEntity booking;

  const QrCodeWidget({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final String qrData = booking.id;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.border.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Center(
            child: QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 150,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: AppColors.textPrimary,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          AppLocale.showQrOnArrival.getString(context),
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}