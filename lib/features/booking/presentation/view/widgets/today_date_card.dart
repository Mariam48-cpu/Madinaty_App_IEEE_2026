import 'package:flutter/material.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';

class TodayDateCard extends StatelessWidget {
  final DateTime date;
  final VoidCallback onTap;

  const TodayDateCard({
    super.key,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 20,
              color: AppColors.primaryDark,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${date.day} / ${date.month} / ${date.year}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}