import 'package:flutter/material.dart';
import '../../../domain/entities/rating_breakdown_entity.dart';

class CategoryRatingBreakdownCard extends StatelessWidget {
  final RatingBreakdownEntity breakdown;

  const CategoryRatingBreakdownCard({
    super.key,
    required this.breakdown,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFF3E7DC),
          width: 1,
        ),
      ),
      child: Column(
        children: [5, 4, 3, 2, 1].map((star) {
          final count = breakdown.starCounts[star] ?? 0;
          final percentage = breakdown.getStarPercentage(star);
          final isLast = star == 1;

          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
            child: _buildStarRow(
              star: star,
              count: count,
              percentage: percentage,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStarRow({
    required int star,
    required int count,
    required double percentage,
  }) {
    return Row(
      children: [
        // Left: Count
        SizedBox(
          width: 28,
          child: Text(
            '$count',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF7D726D),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Center: Progress Bar
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 6,
              backgroundColor: const Color(0xFFEADBCE),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF8A5A36),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Right: Star Label (e.g. "5 ★")
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$star',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D2521),
              ),
            ),
            const SizedBox(width: 3),
            const Icon(
              Icons.star_rounded,
              size: 15,
              color: Color(0xFF8A5A36),
            ),
          ],
        ),
      ],
    );
  }
}
