import 'package:flutter/material.dart';

class EmptySearchState extends StatelessWidget {
  final bool hasQuery;
  final VoidCallback onShowNearby;

  const EmptySearchState({
    super.key,
    required this.hasQuery,
    required this.onShowNearby,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 40),

        Center(child: Icon(Icons.search_off, size: 60, color: Colors.grey)),

        SizedBox(height: 12),

        Center(
          child: Text(
            hasQuery
                ? 'مفيش كافيهات مطابقة لبحثك'
                : 'لم يتم العثور على كافيهات قريبة',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),

        SizedBox(height: 25),

        Center(
          child: OutlinedButton(
            onPressed: onShowNearby,
            child: Text('عرض الكافيهات القريبة'),
          ),
        ),
      ],
    );
  }
}
