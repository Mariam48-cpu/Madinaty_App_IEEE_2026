import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/di/injection_container.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/utils/app_toast.dart';
import 'package:madinaty_app_ieee_2026/features/booking/domain/entities/booking_entity.dart';
import 'package:madinaty_app_ieee_2026/features/booking/domain/repositories/booking_repository_interface.dart';
import 'package:madinaty_app_ieee_2026/features/booking/presentation/utils/cafe_name_resolver.dart';
import 'package:madinaty_app_ieee_2026/features/booking/presentation/view/screens/digital_pass_screen.dart';
import 'package:toastification/toastification.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final bookingRepo = sl<BookingRepositoryInterface>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocale.bookingsTitle.getString(context),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: user == null
          ? Center(
              child: Text(
                AppLocale.loginRequiredToProceed.getString(context),
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            )
          : StreamBuilder<List<BookingEntity>>(
              stream: bookingRepo.watchUserBookings(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      '${AppLocale.toastError.getString(context)}: ${snapshot.error}',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                }

                final bookings = snapshot.data ?? [];

                if (bookings.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.calendar_today_outlined,
                            size: 48,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocale.noBookingsFoundYet.getString(context),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocale.bookingsSubtitle.getString(context),
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: bookings.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return _BookingCard(booking: booking);
                  },
                );
              },
            ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingEntity booking;

  const _BookingCard({required this.booking});

  bool get _canCancel =>
      booking.status == BookingStatus.pending ||
      booking.status == BookingStatus.approved;

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.approved:
      case BookingStatus.completed:
        return Colors.green;
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.rejected:
      case BookingStatus.cancelled:
        return AppColors.error;
    }
  }

  String _getStatusText(BuildContext context, BookingStatus status) {
    switch (status) {
      case BookingStatus.approved:
        return AppLocale.statusConfirmed.getString(context);
      case BookingStatus.completed:
        return AppLocale.statusCompleted.getString(context);
      case BookingStatus.pending:
        return AppLocale.statusPending.getString(context);
      case BookingStatus.rejected:
        return AppLocale.statusRejected.getString(context);
      case BookingStatus.cancelled:
        return AppLocale.statusCancelled.getString(context);
    }
  }

  Future<void> _showCancelConfirmation(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.error),
            const SizedBox(width: 8),
            Text(
              AppLocale.cancelBooking.getString(context),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          AppLocale.cancelBookingConfirmMsg.getString(context),
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              AppLocale.cancelBack.getString(context),
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(AppLocale.yesCancelBooking.getString(context)),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      _cancelBooking(context);
    }
  }

  Future<void> _cancelBooking(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    try {
      final bookingRepo = sl<BookingRepositoryInterface>();
      await bookingRepo.cancelBooking(booking.id);

      if (context.mounted) {
        Navigator.of(context).pop();
        AppToast.showToast(
          context: context,
          title: AppLocale.toastSuccess.getString(context),
          description: AppLocale.bookingCancelledSuccess.getString(context),
          type: ToastificationType.success,
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        AppToast.showToast(
          context: context,
          title: AppLocale.toastError.getString(context),
          description: e.toString().replaceAll('Exception: ', ''),
          type: ToastificationType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(booking.status);
    final statusText = _getStatusText(context, booking.status);
    final dateStr = booking.date != null
        ? '${booking.date!.year}-${booking.date!.month.toString().padLeft(2, '0')}-${booking.date!.day.toString().padLeft(2, '0')}'
        : '—';

    final directName = booking.cafeName ?? CafeNameResolver.getCachedName(booking.cafeId);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: directName != null && directName.isNotEmpty
          ? _buildCardContent(context, directName, statusColor, statusText, dateStr)
          : FutureBuilder<String>(
              future: CafeNameResolver.resolveCafeName(booking.cafeId),
              builder: (context, snapshot) {
                final resolvedName = snapshot.data ?? AppLocale.bookTable.getString(context);
                return _buildCardContent(
                  context,
                  resolvedName,
                  statusColor,
                  statusText,
                  dateStr,
                );
              },
            ),
    );
  }

  Widget _buildCardContent(
    BuildContext context,
    String cafeName,
    Color statusColor,
    String statusText,
    String dateStr,
  ) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DigitalPassScreen(
                booking: booking,
                cafeName: cafeName,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      cafeName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    dateStr,
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.access_time, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      booking.time ?? '—',
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.people_outline, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    '${booking.guests}',
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                ],
              ),
              if (booking.seatingPreference != null &&
                  booking.seatingPreference!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.chair_outlined, size: 16, color: AppColors.textMuted),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        booking.seatingPreference!,
                        style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              if (_canCancel) ...[
                const SizedBox(height: 10),
                const Divider(color: AppColors.border, height: 1),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => _showCancelConfirmation(context),
                    icon: const Icon(
                      Icons.cancel_outlined,
                      size: 16,
                      color: AppColors.error,
                    ),
                    label: Text(
                      AppLocale.cancelBooking.getString(context),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
