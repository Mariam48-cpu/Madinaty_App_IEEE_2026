import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'seating_table.dart';

class SeatingMap extends StatelessWidget {
  final String? selectedTable;
  final String filterCategory;
  final ValueChanged<String> onTableSelected;

  const SeatingMap({
    super.key,
    required this.selectedTable,
    required this.onTableSelected,
    required this.filterCategory,
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
                booked: false,
                onTap: () => onTableSelected('T1'),
              ),
            ),
          if (isTableMatchingFilter(context, tableCategories['T2']))
            Positioned(
              top: 42,
              left: 105,
              child: SeatingTable(
                id: 'T2',
                selected: selectedTable == 'T2',
                booked: false,
                rectangle: true,
                onTap: () => onTableSelected('T2'),
              ),
            ),
          if (isTableMatchingFilter(context, tableCategories['T3']))
            Positioned(
              top: 42,
              left: 25,
              child: SeatingTable(
                id: 'T3',
                selected: selectedTable == 'T3',
                booked: false,
                onTap: () => onTableSelected('T3'),
              ),
            ),
          if (isTableMatchingFilter(context, tableCategories['T4']))
            Positioned(
              top: 125,
              right: 60,
              child: SeatingTable(
                id: 'T4',
                selected: selectedTable == 'T4',
                booked: false,
                onTap: () => onTableSelected('T4'),
              ),
            ),
          if (isTableMatchingFilter(context, tableCategories['T5']))
            Positioned(
              top: 115,
              left: 65,
              child: SeatingTable(
                id: 'T5',
                selected: selectedTable == 'T5',
                booked: false,
                size: 68,
                onTap: () => onTableSelected('T5'),
              ),
            ),
          if (isTableMatchingFilter(context, tableCategories['T6']))
            Positioned(
              top: 215,
              left: 120,
              child: SeatingTable(
                id: 'T6',
                selected: selectedTable == 'T6',
                booked: true,
                onTap: () {},
              ),
            ),
          if (isTableMatchingFilter(context, tableCategories['T7']))
            Positioned(
              top: 215,
              right: 110,
              child: SeatingTable(
                id: 'T7',
                selected: selectedTable == 'T7',
                booked: false,
                onTap: () => onTableSelected('T7'),
              ),
            ),
          if (isTableMatchingFilter(context, tableCategories['BAR']))
            Positioned(
              bottom: 18,
              right: 20,
              child: GestureDetector(
                onTap: () => onTableSelected('BAR'),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  decoration: BoxDecoration(
                    color: selectedTable == 'BAR'
                        ? AppColors.primaryDark
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(10),
                    border: selectedTable == 'BAR'
                        ? Border.all(color: AppColors.primary, width: 1.5)
                        : null,
                  ),
                  child: Text(
                    barText,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: selectedTable == 'BAR'
                          ? AppColors.textWhite
                          : AppColors.textSecondary,
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