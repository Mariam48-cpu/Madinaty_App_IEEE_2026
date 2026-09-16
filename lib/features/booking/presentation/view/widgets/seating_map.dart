import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'seating_table.dart';

class SeatingMap extends StatelessWidget {
  final String? selectedTable;
  final String filterCategory;
  final ValueChanged<String> onTableSelected;
  final List<String> bookedTables;

  const SeatingMap({
    super.key,
    required this.selectedTable,
    required this.onTableSelected,
    required this.filterCategory,
    this.bookedTables = const [],
  });

  bool isTableMatchingFilter(BuildContext context, String? category) {
    if (category == null) return false;
    if (filterCategory == AppLocale.filterAll.getString(context)) return true;
    return filterCategory == category;
  }

  @override
  Widget build(BuildContext context) {
    final nileView = AppLocale.filterNileView.getString(context);
    final quietCorner = AppLocale.filterQuietCorner.getString(context);
    final nextToWindow = AppLocale.filterNextToWindow.getString(context);
    final barText = AppLocale.barAreaTitle.getString(context);
    final allFilter = AppLocale.filterAll.getString(context);

    final Map<String, String> tableCategories = {
      'T1': nileView,
      'T2': nileView,
      'T3': nextToWindow,
      'T4': quietCorner,
      'T5': quietCorner,
      'T6': nextToWindow,
      'T7': nileView,
      'BAR': barText,
    };

    final isT1Booked = bookedTables.contains('T1');
    final isT2Booked = bookedTables.contains('T2');
    final isT3Booked = bookedTables.contains('T3');
    final isT4Booked = bookedTables.contains('T4');
    final isT5Booked = bookedTables.contains('T5');
    final isT6Booked = bookedTables.contains('T6');
    final isT7Booked = bookedTables.contains('T7');
    final isBarBooked = bookedTables.contains('BAR');

    return Container(
      height: 320,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 12,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                filterCategory == allFilter
                    ? AppLocale.seatingMapTitle.getString(context)
                    : filterCategory,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (isTableMatchingFilter(context, tableCategories['T1']))
            Positioned(
              top: 42,
              right: 28,
              child: SeatingTable(
                id: 'T1',
                selected: selectedTable == 'T1',
                booked: isT1Booked,
                onTap: isT1Booked ? () {} : () => onTableSelected('T1'),
              ),
            ),
          if (isTableMatchingFilter(context, tableCategories['T2']))
            Positioned(
              top: 42,
              left: 105,
              child: SeatingTable(
                id: 'T2',
                selected: selectedTable == 'T2',
                booked: isT2Booked,
                rectangle: true,
                onTap: isT2Booked ? () {} : () => onTableSelected('T2'),
              ),
            ),
          if (isTableMatchingFilter(context, tableCategories['T3']))
            Positioned(
              top: 42,
              left: 25,
              child: SeatingTable(
                id: 'T3',
                selected: selectedTable == 'T3',
                booked: isT3Booked,
                onTap: isT3Booked ? () {} : () => onTableSelected('T3'),
              ),
            ),
          if (isTableMatchingFilter(context, tableCategories['T4']))
            Positioned(
              top: 125,
              right: 60,
              child: SeatingTable(
                id: 'T4',
                selected: selectedTable == 'T4',
                booked: isT4Booked,
                onTap: isT4Booked ? () {} : () => onTableSelected('T4'),
              ),
            ),
          if (isTableMatchingFilter(context, tableCategories['T5']))
            Positioned(
              top: 115,
              left: 65,
              child: SeatingTable(
                id: 'T5',
                selected: selectedTable == 'T5',
                booked: isT5Booked,
                size: 68,
                onTap: isT5Booked ? () {} : () => onTableSelected('T5'),
              ),
            ),
          if (isTableMatchingFilter(context, tableCategories['T6']))
            Positioned(
              top: 215,
              left: 120,
              child: SeatingTable(
                id: 'T6',
                selected: selectedTable == 'T6',
                booked: isT6Booked,
                onTap: isT6Booked ? () {} : () => onTableSelected('T6'),
              ),
            ),
          if (isTableMatchingFilter(context, tableCategories['T7']))
            Positioned(
              top: 215,
              right: 110,
              child: SeatingTable(
                id: 'T7',
                selected: selectedTable == 'T7',
                booked: isT7Booked,
                onTap: isT7Booked ? () {} : () => onTableSelected('T7'),
              ),
            ),
          if (isTableMatchingFilter(context, tableCategories['BAR']))
            Positioned(
              bottom: 18,
              right: 20,
              child: GestureDetector(
                onTap: isBarBooked ? () {} : () => onTableSelected('BAR'),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  decoration: BoxDecoration(
                    color: isBarBooked
                        ? AppColors.surfaceVariant
                        : (selectedTable == 'BAR'
                            ? AppColors.primaryDark
                            : AppColors.surfaceVariant),
                    borderRadius: BorderRadius.circular(10),
                    border: selectedTable == 'BAR' && !isBarBooked
                        ? Border.all(color: AppColors.primary, width: 1.5)
                        : null,
                  ),
                  child: Text(
                    barText,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isBarBooked
                          ? AppColors.textMuted
                          : (selectedTable == 'BAR'
                              ? AppColors.textWhite
                              : AppColors.textSecondary),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}