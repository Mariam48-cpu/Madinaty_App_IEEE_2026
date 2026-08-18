import 'package:flutter/material.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/menu_category_entity.dart';

class MenuCategoryChips extends StatelessWidget {
  final List<MenuCategoryEntity> categories;
  final String selectedCategoryId;
  final ValueChanged<String> onCategorySelected;

  const MenuCategoryChips({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        reverse: true,
        itemCount: categories.length + 1,
        separatorBuilder: (_, __) => SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isAll = index == 0;
          final categoryId = isAll ? 'all' : categories[index - 1].id;
          final categoryName = isAll ? 'الكل' : categories[index - 1].name;
          final isSelected = selectedCategoryId == categoryId;
          return ChoiceChip(
            label: Text(
              categoryName,
              style: TextStyle(
                color: isSelected ? Colors.white : Color(0xFF2D2521),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
            selected: isSelected,
            selectedColor: Color(0xFF8D6654),
            backgroundColor: Color(0xffF6ECE6),
            showCheckmark: false,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected ? Color(0xFF8D6654) : Colors.grey.shade300,
              ),
            ),
            onSelected: (_) {
              onCategorySelected(categoryId);
            },
          );
        },
      ),
    );
  }
}
