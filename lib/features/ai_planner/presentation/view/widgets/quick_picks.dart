import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';

class QuickPicks extends StatelessWidget {
  final List<String> interests;
  final Function(String) onToggle;
  final TextEditingController controller;

  const QuickPicks({
    super.key,
    required this.interests,
    required this.onToggle,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      (
      'Coffee',
      AppLocale.quickPickCoffee.getString(context),
      Icons.coffee_rounded,
      ),
      (
      'Study',
      AppLocale.quickPickStudy.getString(context),
      Icons.menu_book_rounded,
      ),
      (
      'Food',
      AppLocale.quickPickFood.getString(context),
      Icons.restaurant_rounded,
      ),
      (
      'Date',
      AppLocale.quickPickDate.getString(context),
      Icons.favorite_rounded,
      ),
      (
      'Hangout',
      AppLocale.quickPickHangout.getString(context),
      Icons.groups_rounded,
      ),
    ];

    return Wrap(
      spacing: 9,
      runSpacing: 9,
      children: items.map((item) {
        final id = item.$1;
        final label = item.$2;
        final icon = item.$3;
        final selected = interests.contains(id);

        return GestureDetector(
          onTap: () {
            onToggle(id);

            if (controller.text.trim().isEmpty) {
              controller.text =
              '${AppLocale.iWantPrefix.getString(context)} $label';

              controller.selection = TextSelection.fromPosition(
                TextPosition(
                  offset: controller.text.length,
                ),
              );
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: selected ? AppColors.primary : const Color(0xFFE7DDD4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 17,
                  color: selected ? Colors.white : AppColors.primary,
                ),
                const SizedBox(width: 7),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}