import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/features/booking/presentation/view/widgets/cafe_header_card.dart';
import 'package:madinaty_app_ieee_2026/features/booking/presentation/view/widgets/time_grid.dart';
import 'package:madinaty_app_ieee_2026/features/booking/presentation/view/widgets/today_date_card.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

import '../../view_model/cubit/booking_cubit.dart';
import '../../view_model/cubit/booking_state.dart';
import '../widgets/guest_selector.dart';
import '../widgets/ocassion_mini_chip.dart';
import 'booking_date_screen.dart';

class BookTableScreen extends StatelessWidget {
  final CafeEntity cafe;

  const BookTableScreen({super.key, required this.cafe});

  List<Map<String, dynamic>> _getOccasions(BuildContext context) => [
    {
      'title': AppLocale.occasionBirthday.getString(context),
      'value': 'birthday',
      'icon': Icons.cake_outlined,
    },
    {
      'title': AppLocale.occasionAnniversary.getString(context),
      'value': 'anniversary',
      'icon': Icons.favorite_border,
    },
    {
      'title': AppLocale.occasionFriendsOuting.getString(context),
      'value': 'friends_outing',
      'icon': Icons.people_outline,
    },
    {
      'title': AppLocale.occasionWork.getString(context),
      'value': 'work',
      'icon': Icons.work_outline,
    },
    {
      'title': AppLocale.occasionCasualCoffee.getString(context),
      'value': 'casual_coffee',
      'icon': Icons.coffee_outlined,
    },
    {
      'title': AppLocale.occasionOther.getString(context),
      'value': 'other',
      'icon': Icons.more_horiz,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final occasions = _getOccasions(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocale.bookTable.getString(context),
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
      body: BlocBuilder<BookingCubit, BookingState>(
        builder: (context, state) {
          final cubit = context.read<BookingCubit>();

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CafeHeaderCard(
                  cafeName: cafe.name,
                  cafeAddress: cafe.address,
                  cafeImageUrl:
                  cafe.photos.isNotEmpty ? cafe.photos.first : null,
                ),
                const SizedBox(height: 22),
                Text(
                  AppLocale.bookingDayLabel.getString(context),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 10),
                TodayDateCard(
                  date: cubit.date ?? DateTime.now(),
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: cubit.date ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: AppColors.primaryDark,
                              onPrimary: AppColors.textWhite,
                              onSurface: AppColors.textPrimary,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (selectedDate != null) {
                      cubit.selectDate(selectedDate);
                    }
                  },
                ),
                const SizedBox(height: 22),
                Text(
                  AppLocale.numberOfGuestsLabel.getString(context),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 10),
                NewGuestSelector(
                  guests: cubit.guests,
                  onAdd: cubit.incrementGuests,
                  onRemove: cubit.decrementGuests,
                ),
                const SizedBox(height: 22),
                Text(
                  AppLocale.occasionOptionalLabel.getString(context),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: occasions.map((occasion) {
                    final value = occasion['value'] as String;

                    return OccasionMiniChip(
                      title: occasion['title'] as String,
                      selected: cubit.occasion == value,
                      onTap: () {
                        cubit.selectOccasion(value);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 22),
                Text(
                  AppLocale.bookingTimesLabel.getString(context),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 10),
                TimeGrid(
                  selectedTime: cubit.time,
                  onSelected: cubit.selectTime,
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: cubit,
                            child: BookingDateScreen(cafe: cafe),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkButton,
                      foregroundColor: AppColors.onDarkButton,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      AppLocale.proceedToSeatingArea.getString(context),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    AppLocale.bookingTwoHoursNotice.getString(context),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}