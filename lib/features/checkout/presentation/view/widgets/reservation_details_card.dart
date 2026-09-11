import 'package:flutter/material.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_typography.dart';
import 'package:madinaty_app_ieee_2026/features/booking/presentation/utils/cafe_name_resolver.dart';
import '../../../../booking/domain/entities/booking_entity.dart';

class ReservationDetailsCard extends StatelessWidget {
  final BookingEntity booking;

  const ReservationDetailsCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final String bookingDateStr = booking.date != null
        ? '${booking.date!.day}/${booking.date!.month}/${booking.date!.year}'
        : 'غير محدد';
    final String bookingTimeStr = booking.time ?? 'غير محدد';

    final String? directName =
        booking.cafeName ?? CafeNameResolver.getCachedName(booking.cafeId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('تفاصيل الحجز', style: AppTypography.titleLarge),
        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: _buildPlaceholderImage(),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        directName != null && directName.isNotEmpty
                            ? Text(
                                directName,
                                style: AppTypography.titleLarge,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            : FutureBuilder<String>(
                                future: CafeNameResolver.resolveCafeName(
                                  booking.cafeId,
                                ),
                                builder: (context, snapshot) {
                                  return Text(
                                    snapshot.data ??
                                        booking.cafeId
                                            .replaceAll('cafe_', '')
                                            .toUpperCase(),
                                    style: AppTypography.titleLarge,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  );
                                },
                              ),
                        const SizedBox(height: 4),
                        const Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'مدينتي، القاهرة',
                                style: AppTypography.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Divider(color: AppColors.divider, height: 1),
              ),

              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icons.calendar_today_outlined,
                      title: 'التاريخ',
                      value: bookingDateStr,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icons.access_time_rounded,
                      title: 'الوقت',
                      value: bookingTimeStr,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icons.people_outline_rounded,
                      title: 'الضيوف',
                      value: '${booking.guests} أشخاص',
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icons.chair_outlined,
                      title: 'الجلوس',
                      value: booking.seatingPreference ?? 'صالة داخلية',
                    ),
                  ),
                ],
              ),

              if (booking.occasion != null && booking.occasion!.isNotEmpty) ...[
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.card_giftcard,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'مناسبة: ${booking.occasion}',
                        style: AppTypography.labelMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.bodySmall),
              const SizedBox(height: 2),
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
        ),
      ],
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 60,
      height: 60,
      color: AppColors.surfaceVariant,
      child: const Icon(
        Icons.storefront_rounded,
        color: AppColors.primary,
        size: 24,
      ),
    );
  }
}