import 'package:flutter/material.dart';

class CafeHeader extends StatelessWidget {
  final String name;
  final double rating;
  final int reviewsCount;

  const CafeHeader({
    super.key,
    required this.name,
    required this.rating,
    required this.reviewsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: Color(0xFFFFE4D0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Color(0xFFE69A35), size: 14),
                  SizedBox(width: 3),
                  Text(
                    rating.toStringAsFixed(1),
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            Spacer(),

            Expanded(
              flex: 3,
              child: Text(
                name.isNotEmpty ? name : 'كافيه',
                textAlign: TextAlign.right,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2521),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 6),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '($reviewsCount تقييم)',
              style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            ),
            SizedBox(width: 4),
            Icon(Icons.star, color: Colors.amber, size: 14),
            SizedBox(width: 3),
            Text(
              rating.toStringAsFixed(1),
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
