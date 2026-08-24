import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/menu_category_entity.dart';

class PreOrderCategoryChips extends StatelessWidget {
  final List<MenuCategoryEntity> categories;
  final String selectedCategoryId;
  final ValueChanged<String> onCategorySelected;

  const PreOrderCategoryChips({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final allCategories = [
      MenuCategoryEntity(
        id: 'all',
        cafeId: '',
        name: AppLocale.allCategories.getString(context),
        products: const [],
      ),
      ...categories,
    ];

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: allCategories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = allCategories[index];
          final isSelected = selectedCategoryId == cat.id;

          return GestureDetector(
            onTap: () => onCategorySelected(cat.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF6E4027)
                    : const Color(0xFFF6F0EC),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  cat.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : const Color(0xFF554A44),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
