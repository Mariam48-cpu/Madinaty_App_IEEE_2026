import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/features/booking/presentation/view/widgets/ocassion_mini_chip.dart';
import 'package:madinaty_app_ieee_2026/features/booking/presentation/view/widgets/time_grid.dart';
import 'package:madinaty_app_ieee_2026/features/booking/presentation/view/widgets/today_date_card.dart';

import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

import '../../view_model/cubit/booking_cubit.dart';
import '../../view_model/cubit/booking_state.dart';
import '../widgets/cafe_header_card.dart';
import '../widgets/guest_selector.dart';
import 'booking_date_screen.dart';

class BookTableScreen extends StatelessWidget {
  final CafeEntity cafe;

  const BookTableScreen({super.key, required this.cafe});

  static List<Map<String, dynamic>> occasions = [
    {'title': 'عيد ميلاد', 'value': 'عيد ميلاد', 'icon': Icons.cake_outlined},
    {
      'title': 'ذكرى سنوية',
      'value': 'ذكرى سنوية',
      'icon': Icons.favorite_border,
    },
    {
      'title': 'خروجة أصحاب',
      'value': 'خروجة أصحاب',
      'icon': Icons.people_outline,
    },
    {'title': 'شغل', 'value': 'شغل', 'icon': Icons.work_outline},
    {
      'title': 'قهوة عادية',
      'value': 'قهوة عادية',
      'icon': Icons.coffee_outlined,
    },
    {'title': 'مناسبة أخرى', 'value': 'مناسبة أخرى', 'icon': Icons.more_horiz},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'حجز طاولة',
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

                  SizedBox(height: 22),

                  Text(
                    'اليوم',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),

                  SizedBox(height: 10),

                  TodayDateCard(
                    date: cubit.date ?? DateTime.now(),
                    onTap: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: cubit.date ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 30)),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Color(0xFF6E4027),
                                onPrimary: Colors.white,
                                onSurface: Color(0xFF1C130E),
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

                  SizedBox(height: 22),

                  Text(
                    'عدد الأشخاص',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),

                  SizedBox(height: 10),

                  NewGuestSelector(
                    guests: cubit.guests,
                    onAdd: cubit.incrementGuests,
                    onRemove: cubit.decrementGuests,
                  ),

                  SizedBox(height: 22),

                  Text(
                    'المناسبة (اختياري)',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),

                  SizedBox(height: 10),

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

                  SizedBox(height: 22),

                  Text(
                    'أوقات الحجز',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),

                  SizedBox(height: 10),

                  TimeGrid(
                    selectedTime: cubit.time,
                    onSelected: cubit.selectTime,
                  ),

                  SizedBox(height: 28),

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
                        backgroundColor: AppColors.textDark,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'متابعة لاختيار الجلسة',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 8),

                  Center(
                    child: Text(
                      'الحجز لمدة ساعتين',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 11,
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
