import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

import '../../view_model/cubit/booking_cubit.dart';
import '../../view_model/cubit/booking_state.dart';
import '../widgets/occasion_card.dart';
import 'seating_preference_screen.dart';

class OccasionScreen extends StatelessWidget {
  final CafeEntity cafe;

  const OccasionScreen({super.key, required this.cafe});

  List<Map<String, dynamic>> _getOccasions(BuildContext context) => [
    {
      'title': AppLocale.occasionBirthday.getString(context),
      'value': 'birthday',
      'icon': Icons.cake_outlined,
    },
    {
      'title': AppLocale.occasionAnniversary.getString(context),
      'value': 'anniversary',
      'icon': Icons.card_giftcard_outlined,
    },
    {
      'title': AppLocale.occasionWork.getString(context),
      'value': 'work',
      'icon': Icons.work_outline,
    },
    {
      'title': AppLocale.occasionFriendsOuting.getString(context),
      'value': 'friends_outing',
      'icon': Icons.people_outline,
    },
    {
      'title': AppLocale.occasionCasualCoffee.getString(context),
      'value': 'casual_coffee',
      'icon': Icons.coffee_outlined,
    },
    {
      'title': AppLocale.occasionOther.getString(context),
      'value': 'other',
      'icon': Icons.auto_awesome_outlined,
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
          AppLocale.whatAreYouPlanningTitle.getString(context),
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
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

          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocale.chooseOccasionSubtitle.getString(context),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 22),
                Expanded(
                  child: GridView.builder(
                    itemCount: occasions.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
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
                const SizedBox(height: 14),
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
                      backgroundColor: AppColors.darkButton,
                      disabledBackgroundColor: AppColors.border,
                      foregroundColor: AppColors.onDarkButton,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      AppLocale.nextButtonText.getString(context),
                      style: const TextStyle(
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
    );
  }
}