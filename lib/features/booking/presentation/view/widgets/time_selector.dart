import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';

class TimeSelector extends StatelessWidget {
  final String? selectedTime;
  final ValueChanged<String> onSelected;

  const TimeSelector({
    super.key,
    required this.selectedTime,
    required this.onSelected,
  });

  static const _baseTimes = [
    '05:00',
    '05:30',
    '06:00',
    '06:30',
    '07:00',
    '07:30',
    '08:00',
    '08:30',
    '09:00',
  ];

  @override
  Widget build(BuildContext context) {
    final String pmSuffix = AppLocale.pm.getString(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _baseTimes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 2.4,
      ),
      itemBuilder: (_, index) {
        final timeDisplay = '${_baseTimes[index]} $pmSuffix';
        final selected = timeDisplay == selectedTime;

        return InkWell(
          onTap: () => onSelected(timeDisplay),
          borderRadius: BorderRadius.circular(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.border,
              ),
            ),
            child: Text(
              timeDisplay,
              style: TextStyle(
                color: selected ? AppColors.textWhite : AppColors.textPrimary,
                fontSize: 11,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }
}