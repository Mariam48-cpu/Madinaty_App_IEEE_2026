import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/features/ai_planner/domain/entities/ai_plan_entity.dart';

import 'result_badge.dart';

class ResultHeader extends StatelessWidget {
  final AIPlanEntity plan;

  const ResultHeader({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFFC18A61)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 19,
                ),
              ),
              const SizedBox(width: 11),
              Text(
                AppLocale.aiPlanReadyTitle.getString(context),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            plan.headline,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            plan.summary,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.88),
              fontSize: 13,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 19),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ResultBadge(
                text:
                '${plan.activities.length} ${AppLocale.placesCountText.getString(context)}',
              ),
              ResultBadge(
                text:
                '${plan.estimatedTotal.round()} ${AppLocale.currency.getString(context)}',
              ),
              if (plan.weatherSummary.isNotEmpty)
                ResultBadge(text: plan.weatherSummary),
            ],
          ),
        ],
      ),
    );
  }
}