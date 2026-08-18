import 'package:flutter/material.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

import 'cafe_card.dart';

class CafeResultsSection extends StatelessWidget {
  final List<CafeEntity> cafes;
  final String query;

  const CafeResultsSection({
    super.key,
    required this.cafes,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    final displayedCafes = cafes.take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${cafes.length} نتيجة',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),

            Text(
              query.isEmpty ? 'شائع الآن في منطقتك' : 'نتائج "$query"',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        SizedBox(height: 14),

        if (displayedCafes.isEmpty)
          SizedBox(
            height: 80,
            child: Center(
              child: Text(
                'لم يتم العثور على كافيهات',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          SizedBox(
            height: 225,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              reverse: true,
              itemCount: displayedCafes.length,
              itemBuilder: (_, index) {
                return CafeCard(cafe: displayedCafes[index]);
              },
            ),
          ),
      ],
    );
  }
}
