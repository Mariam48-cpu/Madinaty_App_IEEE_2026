import 'package:flutter/material.dart';

class ProcessingSteps extends StatelessWidget {
  final int processingStep;

  const ProcessingSteps({
    super.key,
    required this.processingStep,
  });

  @override
  Widget build(BuildContext context) {
    final steps = [
      'بفهم طلبك',
      'بدور على أماكن قريبة',
      'براجع حالة الجو',
      'ببني الـ itinerary بتاعك',
    ];

    return Column(
      children: List.generate(
        steps.length,
        (index) {
          final completed =
              index < processingStep;

          final active =
              index == processingStep;

          return Padding(
            padding:
                const EdgeInsets.only(bottom: 14),
            child: Row(
              children: [
                AnimatedContainer(
                  duration:
                      const Duration(milliseconds: 250),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: completed || active
                        ? const Color(0xFF8B5E3C)
                        : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: completed || active
                          ? const Color(0xFF8B5E3C)
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
                        : const Color(0xFF82756D),
                  ),
                ),

                const SizedBox(width: 12),

                Text(
                  steps[index],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        active || completed
                            ? FontWeight.w700
                            : FontWeight.w500,
                    color: active || completed
                        ? const Color(0xFF2E241F)
                        : const Color(0xFF82756D),
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