import 'package:flutter/material.dart';

class CategoryFilterChips extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const CategoryFilterChips({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  static const List<String> filters = [
    'الأعلى تقييمًا',
    'الأقرب',
    'مفتوح الآن',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        reverse: true,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (_, __) {
          return const SizedBox(width: 8);
        },
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onSelected(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
              decoration: BoxDecoration(
                color: selectedIndex == index
                    ? Color(0xFF8D5F35)
                    : Color(0xFFF8F1EC),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: selectedIndex == index
                      ? Color(0xFF8D5F35)
                      : Color(0xFFE4D8CF),
                ),
              ),
              child: Text(
                filters[index],
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selectedIndex == index
                      ? FontWeight.bold
                      : FontWeight.w500,
                  color: selectedIndex == index
                      ? Colors.white
                      : Color(0xFF6D5A4D),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
