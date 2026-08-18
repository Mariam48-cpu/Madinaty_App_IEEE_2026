import 'package:flutter/material.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/widgets/search/recent_search_item.dart';

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
            return RecentSearchItem(
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
