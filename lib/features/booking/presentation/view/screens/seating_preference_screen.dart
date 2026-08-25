import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/routes/app_routes.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/utils/app_toast.dart';
import 'package:madinaty_app_ieee_2026/features/booking/domain/entities/booking_entity.dart';
import 'package:madinaty_app_ieee_2026/features/booking/presentation/view/widgets/cafe_header_card.dart';
import 'package:madinaty_app_ieee_2026/features/booking/presentation/view/widgets/legend_item.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';
import 'package:toastification/toastification.dart';

import '../../view_model/cubit/booking_cubit.dart';
import '../../view_model/cubit/booking_state.dart';
import '../widgets/booking_summary_card.dart';
import '../widgets/seating_filter_chip.dart';
import '../widgets/seating_map.dart';

class SeatingPreferenceScreen extends StatefulWidget {
  final CafeEntity cafe;

  const SeatingPreferenceScreen({super.key, required this.cafe});

  @override
  State<SeatingPreferenceScreen> createState() =>
      _SeatingPreferenceScreenState();
}

class _SeatingPreferenceScreenState extends State<SeatingPreferenceScreen> {
  int _selectedFilterIndex = 0;
  String? selectedTable = 'T3';

  List<String> _getFilters(BuildContext context) => [
    AppLocale.filterAll.getString(context),
    AppLocale.filterNileView.getString(context),
    AppLocale.filterQuietCorner.getString(context),
    AppLocale.filterNextToWindow.getString(context),
  ];

  @override
  Widget build(BuildContext context) {
    final filters = _getFilters(context);
    final selectedFilter = filters[_selectedFilterIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocale.selectSeatingArea.getString(context),
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textDark,
            size: 18,
          ),
        ),
      ),
      body: BlocConsumer<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is BookingSuccess) {
            final cubit = context.read<BookingCubit>();
            final booking = BookingEntity(
              id: state.bookingId,
              userId: FirebaseAuth.instance.currentUser?.uid ?? 'guest_user',
              cafeId: widget.cafe.id,
              date: cubit.date ?? DateTime.now(),
              time: cubit.time ?? '18:00',
              guests: cubit.guests,
              occasion: cubit.occasion ?? 'casual_coffee',
              seatingPreference: selectedTable ?? 'T3',
              status: BookingStatus.pending,
              createdAt: DateTime.now(),
            );

            Navigator.pushNamed(
              context,
              AppRoutes.preOrder,
              arguments: {
                'booking': booking,
                'cafeId': widget.cafe.id,
                'cafeName': widget.cafe.name,
                'cafe': widget.cafe,
              },
            );
          }

          if (state is BookingFailure) {
            AppToast.showToast(
              context: context,
              title: AppLocale.toastError.getString(context),
              description: state.message,
              type: ToastificationType.error,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<BookingCubit>();
          final isLoading = state is BookingLoading;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CafeHeaderCard(
                        cafeName: widget.cafe.name,
                        cafeAddress: widget.cafe.address,
                        cafeImageUrl: widget.cafe.photos.isNotEmpty
                            ? widget.cafe.photos.first
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${AppLocale.time.getString(context)}: ${cubit.time ?? '--'}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            Text(
                              '${AppLocale.numberOfGuestsLabel.getString(context)}: ${cubit.guests}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LegendItem(
                            title: AppLocale.legendAvailable.getString(context),
                            color: AppColors.chipBackground,
                          ),
                          const SizedBox(width: 18),
                          LegendItem(
                            title: AppLocale.legendSelected.getString(context),
                            color: AppColors.primaryDark,
                          ),
                          const SizedBox(width: 18),
                          LegendItem(
                            title: AppLocale.legendBooked.getString(context),
                            color: AppColors.surfaceVariant,
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        height: 38,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: filters.length,
                          separatorBuilder: (context, index) =>
                          const SizedBox(width: 7),
                          itemBuilder: (context, index) {
                            final filter = filters[index];

                            return SeatingFilterChip(
                              title: filter,
                              selected: _selectedFilterIndex == index,
                              onTap: () {
                                setState(() {
                                  _selectedFilterIndex = index;
                                });
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 18),
                      SeatingMap(
                        filterCategory: selectedFilter,
                        selectedTable: selectedTable,
                        onTableSelected: (table) {
                          setState(() {
                            selectedTable = table;
                          });
                        },
                      ),
                      const SizedBox(height: 18),
                      Text(
                        AppLocale.chooseSuitablePlaceHint.getString(context),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(22),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    BookingSummaryCard(
                      table: selectedTable ?? 'T3',
                      time: cubit.time,
                      guests: cubit.guests,
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                          if (selectedTable == null) {
                            AppToast.showToast(
                              context: context,
                              title: AppLocale.toastError
                                  .getString(context),
                              description: AppLocale.selectFirstTableError
                                  .getString(context),
                              type: ToastificationType.warning,
                            );
                            return;
                          }

                          cubit.selectSeatingPreference(selectedTable!);
                          cubit.createBooking();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkButton,
                          disabledBackgroundColor: AppColors.border,
                          foregroundColor: AppColors.onDarkButton,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: AppColors.textWhite,
                            strokeWidth: 2,
                          ),
                        )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocale.confirmBookingButton
                                  .getString(context),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}