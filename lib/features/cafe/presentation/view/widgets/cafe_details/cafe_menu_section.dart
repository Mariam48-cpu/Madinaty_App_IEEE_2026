import 'package:flutter/material.dart';

import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/menu_category_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/product_entity.dart';

import 'full_menu.dart';
import 'popular_products.dart';

class CafeMenuSection extends StatelessWidget {
  final List<MenuCategoryEntity> menu;
  final void Function(ProductEntity product)? onProductTap;

  const CafeMenuSection({super.key, required this.menu, this.onProductTap});

  @override
  Widget build(BuildContext context) {
    if (menu.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8F4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'القائمة غير متاحة حاليًا',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, color: Color(0xFF806C61)),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PopularProducts(menu: menu, onProductTap: onProductTap),

        FullMenu(menu: menu, onProductTap: onProductTap),
      ],
    );
  }
}
