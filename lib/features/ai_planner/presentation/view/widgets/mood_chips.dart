import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';

class MoodChips extends StatelessWidget {
  final String? selectedMood;
  final Function(String?) onMoodSelected;

  const MoodChips({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    final moods = [
      {'id': 'calm', 'label': AppLocale.moodCalm.getString(context)},
      {'id': 'cheerful', 'label': AppLocale.moodCheerful.getString(context)},
      {'id': 'romantic', 'label': AppLocale.moodRomantic.getString(context)},
      {'id': 'social', 'label': AppLocale.moodSocial.getString(context)},
      {'id': 'productive', 'label': AppLocale.moodProductive.getString(context)},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: moods.map((mood) {
          final id = mood['id']!;
          final label = mood['label']!;
          final selected = selectedMood == id || selectedMood == label;

          return Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: GestureDetector(
              onTap: () {
                onMoodSelected(selected ? null : id);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: selected ? AppColors.primary : const Color(0xFFE7DDD4),
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: selected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}