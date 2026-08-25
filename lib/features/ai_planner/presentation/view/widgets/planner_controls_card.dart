import 'package:flutter/material.dart';

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
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
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
                  title: 'الميزانية',
                  value: '${budget.round()} جنيه',
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _buildValueTile(
                  icon: Icons.schedule_rounded,
                  title: 'الوقت',
                  value: '$durationHours ساعات',
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF8B5E3C),
              inactiveTrackColor:
                  const Color(0xFF8B5E3C).withOpacity(.12),
              thumbColor: const Color(0xFF8B5E3C),
              overlayColor:
                  const Color(0xFF8B5E3C).withOpacity(.08),
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
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              _smallLabel('1500 جنيه'),
              _smallLabel('100 جنيه'),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              const Text(
                'الوقت المتاح',
                style: TextStyle(
                  color: Color(0xFF2E241F),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),

              const Spacer(),

              IconButton(
                onPressed: durationHours > 1
                    ? () => onDurationChanged(
                          durationHours - 1,
                        )
                    : null,
                icon: const Icon(
                  Icons.remove_circle_outline,
                ),
              ),

              Text(
                '$durationHours ساعات',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E241F),
                ),
              ),

              IconButton(
                onPressed: durationHours < 8
                    ? () => onDurationChanged(
                          durationHours + 1,
                        )
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
        color: const Color(0xFFF8F3EC),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: const Color(0xFF8B5E3C),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                _smallLabel(title),

                const SizedBox(height: 2),

                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF2E241F),
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
        color: Color(0xFF82756D),
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}