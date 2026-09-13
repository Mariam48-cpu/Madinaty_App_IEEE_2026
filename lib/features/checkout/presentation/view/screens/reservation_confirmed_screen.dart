import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_typography.dart';
import '../../../../booking/domain/entities/booking_entity.dart';
import '../../../../../core/routes/app_routes.dart';

class ReservationConfirmedScreen extends StatelessWidget {
  final BookingEntity booking;

  const ReservationConfirmedScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final String bookingDateStr = booking.date != null
        ? '${booking.date!.day}/${booking.date!.month}/${booking.date!.year}'
        : AppLocale.today.getString(context);
    final String bookingTimeStr = booking.time ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.successContainer,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocale.bookingConfirmedTitle.getString(context),
                style: AppTypography.headlineLarge,
              ),
              const SizedBox(height: 6),
              Text(
                AppLocale.bookingConfirmedSubtitle.getString(context),
                style: AppTypography.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocale.bookingNumberLabel.getString(context),
                          style: AppTypography.bodySmall,
                        ),
                        Text(
                          booking.id.isNotEmpty && booking.id.length >= 8
                              ? '#${booking.id.substring(0, 8).toUpperCase()}'
                              : '#MD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: AppColors.divider, height: 1),
                    ),
                    _buildTicketRow(
                      label: AppLocale.cafeLabel.getString(context),
                      value: (booking.cafeName != null && booking.cafeName!.isNotEmpty)
                          ? booking.cafeName!
                          : booking.cafeId,
                      icon: Icons.storefront_rounded,
                    ),
                    const SizedBox(height: 12),
                    _buildTicketRow(
                      label: AppLocale.dateTimeLabel.getString(context),
                      value: '$bookingDateStr ${bookingTimeStr.isNotEmpty ? "• $bookingTimeStr" : ""}',
                      icon: Icons.calendar_month_outlined,
                    ),
                    const SizedBox(height: 12),
                    _buildTicketRow(
                      label: AppLocale.detailsLabel.getString(context),
                      value:
                      '${booking.guests} ${AppLocale.guestsSuffix.getString(context)} • ${booking.seatingPreference ?? AppLocale.indoorSeating.getString(context)}',
                      icon: Icons.people_outline_rounded,
                    ),
                    const SizedBox(height: 12),
                    _buildTicketRow(
                      label: AppLocale.paidAmountLabel.getString(context),
                      value: '50.0 ${AppLocale.currencyEgp.getString(context)}',
                      icon: Icons.receipt_long_outlined,
                      isHighlight: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.digitalPass,
                      arguments: {
                        'booking': booking,
                        'cafeName': booking.cafeName,
                        'cafeLocation': booking.cafeLocation,
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkButton,
                    foregroundColor: AppColors.onDarkButton,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.qr_code_rounded, size: 20),
                  label: Text(
                    AppLocale.viewDigitalPassBtn.getString(context),
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.onDarkButton,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.home,
                          (route) => false,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.border, width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    AppLocale.backToHomeBtn.getString(context),
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.orders,
                        (route) => false,
                  );
                },
                icon: const Icon(
                  Icons.bookmark_border_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
                label: Text(
                  AppLocale.viewMyBookingsBtn.getString(context),
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketRow({
    required String label,
    required String value,
    required IconData icon,
    bool isHighlight = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: AppTypography.titleSmall.copyWith(
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
            color: isHighlight ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}