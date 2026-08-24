import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';

class ProcessingSteps extends StatelessWidget {
  final int processingStep;

  const ProcessingSteps({
    super.key,
    required this.processingStep,
  });

  @override
  Widget build(BuildContext context) {
    final steps = [
      AppLocale.aiStepUnderstanding.getString(context),
      AppLocale.aiStepSearchingPlaces.getString(context),
      AppLocale.aiStepCheckingWeather.getString(context),
      AppLocale.aiStepBuildingItinerary.getString(context),
    ];

    return Column(
      children: List.generate(
        steps.length,
            (index) {
          final completed = index < processingStep;
          final active = index == processingStep;

          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: completed || active
                        ? AppColors.primary
                        : AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: completed || active
                          ? AppColors.primary
                          : const Color(0xFFE7DDD4),
                    ),
                  ),
                  child: Icon(
                    completed
                        ? Icons.check_rounded
                        : active
                        ? Icons.auto_awesome_rounded
                        : Icons.circle_outlined,
                    size: 15,
                    color: completed || active
                        ? Colors.white
                        : AppColors.textMuted,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  steps[index],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                    active || completed ? FontWeight.w700 : FontWeight.w500,
                    color: active || completed
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
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