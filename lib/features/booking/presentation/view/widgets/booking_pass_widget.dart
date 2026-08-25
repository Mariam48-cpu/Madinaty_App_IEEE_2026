import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_typography.dart';
import '../../../domain/entities/booking_entity.dart';
import 'pass_status_badge.dart';
import 'qr_code_widget.dart';

class BookingPassWidget extends StatelessWidget {
  final BookingEntity booking;
  final String? cafeName;
  final String? cafeLocation;

  const BookingPassWidget({
    super.key,
    required this.booking,
    this.cafeName,
    this.cafeLocation,
  });

  @override
  Widget build(BuildContext context) {
    final String resolvedCafeName =
        cafeName ?? AppLocale.defaultCafeName.getString(context);
    final String resolvedCafeLocation =
        cafeLocation ?? AppLocale.defaultCafeLocation.getString(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PassStatusBadge(status: booking.status),
          const SizedBox(height: 14),
          Text(
            resolvedCafeName,
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            resolvedCafeLocation,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          QrCodeWidget(booking: booking),
          const SizedBox(height: 24),
          _buildDashedDivider(),
          const SizedBox(height: 20),
          _buildDetailsGrid(context),
        ],
      ),
    );
  }

  Widget _buildDetailsGrid(BuildContext context) {
    final String notSpecified = AppLocale.notSpecifiedText.getString(context);
    final String formattedDate = booking.date != null
        ? '${booking.date!.day}/${booking.date!.month}/${booking.date!.year}'
        : notSpecified;

    final String timeStr = booking.time ?? notSpecified;
    final String seatingStr =
        booking.seatingPreference ?? AppLocale.filterQuietCorner.getString(context);
    final String guestsStr =
        '${booking.guests} ${AppLocale.guestsCountText.getString(context)}';

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDetailColumn(
              title: AppLocale.date.getString(context),
              value: formattedDate,
            ),
            _buildDetailColumn(
              title: AppLocale.time.getString(context),
              value: timeStr,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDetailColumn(
              title: AppLocale.seating.getString(context),
              value: seatingStr,
            ),
            _buildDetailColumn(
              title: AppLocale.guests.getString(context),
              value: guestsStr,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailColumn({
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDashedDivider() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double dashWidth = 5;
        const double dashSpace = 4;
        final int dashCount =
        (constraints.constrainWidth() / (dashWidth + dashSpace)).floor();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: dashWidth,
              height: 1.5,
              child: DecoratedBox(
                decoration: BoxDecoration(color: AppColors.border),
              ),
            );
          }),
        );
      },
    );
  }
}