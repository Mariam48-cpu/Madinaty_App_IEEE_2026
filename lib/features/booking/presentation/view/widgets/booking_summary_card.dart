import 'package:flutter/material.dart';

class BookingSummaryCard extends StatelessWidget {
  final String table;
  final String? time;
  final int guests;

  const BookingSummaryCard({
    super.key,
    required this.table,
    required this.time,
    required this.guests,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تم تحديد',
              style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            ),
             SizedBox(height: 4),
            Text(
              'طاولة $table',
              style:  TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
             Text(
              'إطلالة النيل',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
             SizedBox(height: 4),
            Text(
              '$guests أشخاص • ${time ?? '--'}',
              style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            ),
          ],
        ),
      ],
    );
  }
}
