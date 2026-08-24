import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';

class PlannerControlsCard extends StatelessWidget {
  final double budget;
  final int durationHours;
  final ValueChanged<double> onBudgetChanged;
  final ValueChanged<int> onDurationChanged;

  const PlannerControlsCard({
    super.key,
    required this.budget,
    required this.durationHours,
    required this.onBudgetChanged,
    required this.onDurationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final currency = AppLocale.currency.getString(context);
    final hoursText = AppLocale.hours.getString(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE7DDD4),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildValueTile(
                  icon: Icons.account_balance_wallet_outlined,
                  title: AppLocale.budget.getString(context),
                  value: '${budget.round()} $currency',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildValueTile(
                  icon: Icons.schedule_rounded,
                  title: AppLocale.time.getString(context),
                  value: '$durationHours $hoursText',
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.primary.withValues(alpha: 0.12),
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withValues(alpha: 0.08),
            ),
            child: Slider(
              value: budget,
              min: 100,
              max: 1500,
              divisions: 28,
              onChanged: onBudgetChanged,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _smallLabel('100 $currency'),
              _smallLabel('1500 $currency'),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                AppLocale.availableTime.getString(context),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: durationHours > 1
                    ? () => onDurationChanged(durationHours - 1)
                    : null,
                icon: const Icon(
                  Icons.remove_circle_outline,
                ),
              ),
              Text(
                '$durationHours $hoursText',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                onPressed: durationHours < 8
                    ? () => onDurationChanged(durationHours + 1)
                    : null,
                icon: const Icon(
                  Icons.add_circle_outline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValueTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _smallLabel(title),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}