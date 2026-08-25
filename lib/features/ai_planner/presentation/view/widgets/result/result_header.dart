import 'package:flutter/material.dart';
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
          colors: [Color(0xFF8B5E3C), Color(0xFFC18A61)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0x2E8B5E3C),
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
                  color: Colors.white.withOpacity(.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 19,
                ),
              ),

              const SizedBox(width: 11),

              const Text(
                'جهزتلك الخطة 🎉',
                style: TextStyle(
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
            textAlign: TextAlign.right,
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
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.white.withOpacity(.88),
              fontSize: 13,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 19),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ResultBadge(text: '${plan.activities.length} أماكن'),
              ResultBadge(text: '${plan.estimatedTotal.round()} جنيه'),
              ResultBadge(text: plan.weatherSummary),
            ],
          ),
        ],
      ),
    );
  }
}
