import 'package:flutter/material.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';

class TimeSelector extends StatelessWidget {
  final String? selectedTime;
  final ValueChanged<String> onSelected;

  const TimeSelector({
    super.key,
    required this.selectedTime,
    required this.onSelected,
  });

  static List<String> times = [
    '05:00 م',
    '05:30 م',
    '06:00 م',
    '06:30 م',
    '07:00 م',
    '07:30 م',
    '08:00 م',
    '08:30 م',
    '09:00 م',
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: times.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 2.4,
      ),
      itemBuilder: (_, index) {
        final time = times[index];
        final selected = time == selectedTime;

        return InkWell(
          onTap: () => onSelected(time),
          borderRadius: BorderRadius.circular(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected ? AppColors.primary : Color(0xFFE2D9D2),
              ),
            ),
            child: Text(
              time,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black87,
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
