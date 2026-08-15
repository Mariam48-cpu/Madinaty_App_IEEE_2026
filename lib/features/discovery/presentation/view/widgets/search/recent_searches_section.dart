import 'package:flutter/material.dart';

class RecentSearchesSection extends StatelessWidget {
  final List<String> searches;
  final ValueChanged<String> onSearchSelected;
  final ValueChanged<String> onSearchRemoved;
  final VoidCallback onClearAll;

  const RecentSearchesSection({
    super.key,
    required this.searches,
    required this.onSearchSelected,
    required this.onSearchRemoved,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    if (searches.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: onClearAll,
              child: Text(
                'مسح',
                style: TextStyle(color: Color(0xFF8D6654), fontSize: 12),
              ),
            ),

            Text(
              'عمليات البحث الأخيرة',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        SizedBox(height: 12),

        Wrap(
          alignment: WrapAlignment.end,
          spacing: 8,
          runSpacing: 8,
          children: searches.map((search) {
            return _RecentSearchItem(
              search: search,
              onSelected: () {
                onSearchSelected(search);
              },
              onRemoved: () {
                onSearchRemoved(search);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _RecentSearchItem extends StatelessWidget {
  final String search;
  final VoidCallback onSelected;
  final VoidCallback onRemoved;

  _RecentSearchItem({
    required this.search,
    required this.onSelected,
    required this.onRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Color(0xFFF4ECE8),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onRemoved,
            child: Icon(Icons.close, size: 15, color: Colors.grey),
          ),

          SizedBox(width: 5),

          GestureDetector(
            onTap: onSelected,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.history, size: 14, color: Colors.grey),

                SizedBox(width: 5),

                Text(search, style: TextStyle(fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
