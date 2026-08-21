import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';

import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

import '../../view_model/cubit/booking_cubit.dart';
import '../../view_model/cubit/booking_state.dart';
import '../widgets/occasion_card.dart';
import 'seating_preference_screen.dart';

class OccasionScreen extends StatelessWidget {
  final CafeEntity cafe;

  const OccasionScreen({super.key, required this.cafe});

  static List<Map<String, dynamic>> occasions = [
    {'title': 'عيد ميلاد', 'value': 'عيد ميلاد', 'icon': Icons.cake_outlined},
    {
      'title': 'ذكرى سنوية',
      'value': 'ذكرى سنوية',
      'icon': Icons.card_giftcard_outlined,
    },
    {'title': 'شغل', 'value': 'شغل', 'icon': Icons.work_outline},
    {
      'title': 'خروجة أصحاب',
      'value': 'خروجة أصحاب',
      'icon': Icons.people_outline,
    },
    {
      'title': 'قهوة عادية',
      'value': 'قهوة عادية',
      'icon': Icons.coffee_outlined,
    },
    {
      'title': 'مناسبة أخرى',
      'value': 'مناسبة أخرى',
      'icon': Icons.auto_awesome_outlined,
    },
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
          'بتخطط لإيه؟',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
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

            return Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'اختار المناسبة عشان نساعدك نجهز التجربة المناسبة',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),

                  SizedBox(height: 22),

                  Expanded(
                    child: GridView.builder(
                      itemCount: occasions.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.25,
                      ),
                      itemBuilder: (_, index) {
                        final occasion = occasions[index];

                        return OccasionCard(
                          title: occasion['title'] as String,
                          icon: occasion['icon'] as IconData,
                          selected: cubit.occasion == occasion['value'],
                          onTap: () {
                            cubit.selectOccasion(occasion['value'] as String);
                          },
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 14),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: cubit.occasion == null
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: cubit,
                                    child: SeatingPreferenceScreen(cafe: cafe),
                                  ),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.textDark,
                        disabledBackgroundColor: Colors.grey.shade400,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'التالي',
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
