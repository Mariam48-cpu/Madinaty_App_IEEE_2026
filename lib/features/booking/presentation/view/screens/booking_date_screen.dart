import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';

import 'package:madinaty_app_ieee_2026/features/booking/presentation/view/widgets/cafe_header_card.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

import '../../view_model/cubit/booking_cubit.dart';
import '../../view_model/cubit/booking_state.dart';
import '../widgets/date_selector.dart';
import '../widgets/guest_selector.dart';
import '../widgets/time_selector.dart';
import 'occasion_screen.dart';

class BookingDateScreen extends StatelessWidget {
  final CafeEntity cafe;

  const BookingDateScreen({super.key, required this.cafe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'احجز مكانك',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textDark,
            size: 18,
          ),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocBuilder<BookingCubit, BookingState>(
          builder: (context, state) {
            final cubit = context.read<BookingCubit>();

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CafeHeaderCard(
                    cafeName: cafe.name,
                    cafeAddress: cafe.address,
                    cafeImageUrl: cafe.photos.isNotEmpty
                        ? cafe.photos.first
                        : null,
                  ),

                  SizedBox(height: 12),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          cubit.time ?? 'اختاري الوقت',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        Text(
                          '${cubit.guests} أشخاص',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  Text(
                    'عدد الأشخاص',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 10),

                  NewGuestSelector(
                    guests: cubit.guests,
                    onAdd: () {
                      cubit.incrementGuests();
                    },
                    onRemove: () {
                      cubit.decrementGuests();
                    },
                  ),

                  SizedBox(height: 24),

                  Text(
                    'التاريخ',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 10),

                  HorizontalDateSelector(
                    selectedDate: cubit.date,
                    onDateSelected: (date) {
                      cubit.selectDate(date);
                    },
                  ),

                  SizedBox(height: 24),

                  Text(
                    'الوقت',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 10),

                  TimeSelector(
                    selectedTime: cubit.time,
                    onSelected: (time) {
                      cubit.selectTime(time);
                    },
                  ),

                  SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: cubit.date == null || cubit.time == null
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider.value(
                                    value: cubit,
                                    child: OccasionScreen(cafe: cafe),
                                  ),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.textDark,
                        disabledBackgroundColor: Colors.grey.shade400,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'متابعة',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
