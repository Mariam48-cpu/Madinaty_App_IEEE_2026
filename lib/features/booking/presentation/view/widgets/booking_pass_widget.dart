import 'package:flutter/material.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_typography.dart';
import '../../../domain/entities/booking_entity.dart';
import 'pass_status_badge.dart';
import 'qr_code_widget.dart';

class BookingPassWidget extends StatelessWidget {
  final BookingEntity booking;
  final String cafeName;
  final String cafeLocation;

  const BookingPassWidget({
    super.key,
    required this.booking,
    this.cafeName = 'روستري لاب',
    this.cafeLocation = 'التجمع الخامس',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
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
            cafeName,
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),

          Text(
            cafeLocation,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),

          QrCodeWidget(booking: booking),
          const SizedBox(height: 24),

          _buildDashedDivider(),
          const SizedBox(height: 20),

          _buildDetailsGrid(),
        ],
      ),
    );
  }

  Widget _buildDetailsGrid() {
    final String formattedDate = booking.date != null
        ? '${booking.date!.day} ${_getArabicMonth(booking.date!.month)} ${booking.date!.year}'
        : 'غير محدد';

    final String timeStr = booking.time ?? 'غير محدد';
    final String seatingStr = booking.seatingPreference ?? 'ركن هادئ';
    final String guestsStr = '${booking.guests} شخص';

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDetailColumn(title: 'التاريخ', value: formattedDate),
            _buildDetailColumn(title: 'الوقت', value: timeStr),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDetailColumn(title: 'الجلوس', value: seatingStr),
            _buildDetailColumn(title: 'الأشخاص', value: guestsStr),
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
        final int dashCount = (constraints.constrainWidth() / (dashWidth + dashSpace)).floor();

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

  String _getArabicMonth(int month) {
    const months = [
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
    if (month >= 1 && month <= 12) {
      return months[month - 1];
    }
    return '';
  }
}