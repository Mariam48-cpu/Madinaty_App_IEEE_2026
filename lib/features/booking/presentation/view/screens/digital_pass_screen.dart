import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_typography.dart';
import 'package:madinaty_app_ieee_2026/core/utils/app_toast.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';
import 'package:toastification/toastification.dart';
import '../../../domain/entities/booking_entity.dart';
import '../../utils/calendar_helper.dart';
import '../../utils/location_helper.dart';
import '../widgets/booking_pass_widget.dart';

class DigitalPassScreen extends StatelessWidget {
  final BookingEntity booking;
  final CafeEntity? cafe;
  final String? cafeName;
  final String? cafeLocation;
  final double? cafeLatitude;
  final double? cafeLongitude;
  final VoidCallback? onDirectionsPressed;
  final VoidCallback? onAddToCalendarPressed;

  const DigitalPassScreen({
    super.key,
    required this.booking,
    this.cafe,
    this.cafeName,
    this.cafeLocation,
    this.cafeLatitude,
    this.cafeLongitude,
    this.onDirectionsPressed,
    this.onAddToCalendarPressed,
  });

  String get _resolvedCafeName => cafe?.name ?? cafeName ?? '';
  String get _resolvedCafeLocation => cafe?.address ?? cafeLocation ?? '';
  double? get _resolvedLatitude => cafe?.latitude ?? cafeLatitude;
  double? get _resolvedLongitude => cafe?.longitude ?? cafeLongitude;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              _buildTopSearchBar(context),
              const SizedBox(height: 20),
              BookingPassWidget(booking: booking),
              const SizedBox(height: 24),
              _buildActionButtons(context),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withOpacity(0.6),
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
              AppLocale.digitalPassSearchHint.getString(context),
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

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onAddToCalendarPressed ??
                    () async {
                  await CalendarHelper.addBookingToCalendar(
                    context: context,
                    booking: booking,
                    cafeName: _resolvedCafeName.isNotEmpty ? _resolvedCafeName : null,
                    cafeLocation: _resolvedCafeLocation.isNotEmpty ? _resolvedCafeLocation : null,
                  );
                  if (context.mounted) {
                    AppToast.showToast(
                      context: context,
                      title: AppLocale.toastSuccess.getString(context),
                      description: AppLocale.reservationAddedToCalendar.getString(context),
                      type: ToastificationType.success,
                    );
                  }
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
              AppLocale.addToCalendar.getString(context),
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
            onPressed: onDirectionsPressed ??
                    () {
                  MapLauncherHelper.openMapDirections(
                    context: context,
                    latitude: _resolvedLatitude,
                    longitude: _resolvedLongitude,
                    cafeLocationName: _resolvedCafeLocation.isNotEmpty ? _resolvedCafeLocation : _resolvedCafeName,
                  );
                },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: AppColors.darkButton,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(
              Icons.directions_outlined,
              size: 20,
              color: AppColors.onDarkButton,
            ),
            label: Text(
              AppLocale.directions.getString(context),
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.onDarkButton,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}