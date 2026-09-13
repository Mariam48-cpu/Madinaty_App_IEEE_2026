import 'package:flutter/material.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';

class PickedBySection extends StatelessWidget {
  final List<String> names;
  final bool compact;

  const PickedBySection({
    super.key,
    required this.names,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 16 : 18),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(
          compact ? 18 : 20,
        ),
      ),
      child: Column(
        children: [
          Text(
            '☕ Picked by',
            style: TextStyle(
              fontSize: compact ? 15 : 16,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 10),

          if (names.isEmpty)
            const Text('Group members')
          else if (compact)
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 7,
              runSpacing: 7,
              children: names.map((name) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            )
          else
            Text(
              names.join(' • '),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}

