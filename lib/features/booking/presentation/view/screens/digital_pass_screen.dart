import 'package:flutter/material.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_typography.dart';
import '../../../domain/entities/booking_entity.dart';
import '../../utils/calendar_helper.dart';
import '../../utils/location_helper.dart';
import '../widgets/booking_pass_widget.dart';

class DigitalPassScreen extends StatelessWidget {
  final BookingEntity booking;
  final VoidCallback? onDirectionsPressed;
  final VoidCallback? onAddToCalendarPressed;

  const DigitalPassScreen({
    super.key,
    required this.booking,
    this.onDirectionsPressed,
    this.onAddToCalendarPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              _buildTopSearchBar(),
              const SizedBox(height: 20),

              BookingPassWidget(booking: booking),
              const SizedBox(height: 24),

              _buildActionButtons(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search_rounded,
            color: AppColors.textSecondary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'ابحث بالاسم، المنطقة، أو نوع القهوة',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onAddToCalendarPressed ?? () {
              CalendarHelper.addBookingToCalendar(
                booking: booking,
                cafeName: 'روستري لاب',
                cafeLocation: 'التجمع الخامس',
              );
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: AppColors.surface,
              side: const BorderSide(color: AppColors.border, width: 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: AppColors.textPrimary,
            ),
            label: Text(
              'إضافة للتقويم',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        Expanded(
          child: ElevatedButton.icon(
            onPressed: onDirectionsPressed ?? () {
              MapLauncherHelper.openMapDirections(
                cafeLocationName: 'روستري لاب التجمع الخامس',
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: const Color(0xFF1E1815),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(
              Icons.directions_outlined,
              size: 20,
              color: Colors.white,
            ),
            label: Text(
              'الاتجاهات',
              style: AppTypography.labelLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}