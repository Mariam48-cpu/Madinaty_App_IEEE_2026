import 'package:flutter/material.dart';
import 'package:madinaty_app_ieee_2026/features/ai_planner/domain/entities/ai_plan_entity.dart';
import 'result_header.dart';
import 'activity_card.dart';

class ResultScreen extends StatelessWidget {
  final AIPlanEntity plan;
  final VoidCallback onStartAgain;

  const ResultScreen({
    super.key,
    required this.plan,
    required this.onStartAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: CustomScrollView(
        key: const ValueKey('result'),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.fromLTRB(22, 14, 22, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: onStartAgain,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    icon: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Color(0xFF2E241F),
                      size: 20,
                    ),
                  ),

                  const Spacer(),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(13),
                      border: Border.all(
                        color: const Color(0xFFE7DDD4),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          size: 15,
                          color: Color(0xFF8B5E3C),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Madinaty AI',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w700,
                            color:
                                Color(0xFF2E241F),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.fromLTRB(22, 28, 22, 0),
              child: ResultHeader(plan: plan),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.fromLTRB(22, 25, 22, 12),
              child: const Text(
                'خطة يومك',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2E241F),
                ),
              ),
            ),
          ),

          SliverList(
            delegate:
                SliverChildBuilderDelegate(
              (context, index) {
                final activity =
                    plan.activities[index];

                return Padding(
                  padding:
                      const EdgeInsets.fromLTRB(
                    22,
                    0,
                    22,
                    16,
                  ),
                  child: ActivityCard(
                    activity: activity,
                    index: index,
                    totalActivities:
                        plan.activities.length,
                  ),
                );
              },
              childCount: plan.activities.length,
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.fromLTRB(22, 10, 22, 35),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: onStartAgain,
                  icon: const Icon(
                    Icons.refresh_rounded,
                  ),
                  label: const Text(
                    'خطط ليوم تاني',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        const Color(0xFF8B5E3C),
                    side: const BorderSide(
                      color: Color(0xFF8B5E3C),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
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