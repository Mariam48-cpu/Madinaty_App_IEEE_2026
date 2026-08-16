import 'package:flutter/material.dart';

import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/menu_category_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/product_entity.dart';

import 'menu_product_item.dart';

class FullMenu extends StatelessWidget {
  final List<MenuCategoryEntity> menu;
  final void Function(ProductEntity product)? onProductTap;
  const FullMenu({super.key, required this.menu, this.onProductTap});

  @override
  Widget build(BuildContext context) {
    if (menu.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(height: 20),

        Text(
          'القائمة الكاملة',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D2521),
          ),
        ),

        SizedBox(height: 14),

        ...menu.map((category) {
          if (category.products.isEmpty) {
            return SizedBox.shrink();
          }

          return Padding(
            padding: EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  category.name,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6D5143),
                  ),
                ),

                SizedBox(height: 9),

                SizedBox(
                  height: 145,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    itemCount: category.products.length,
                    itemBuilder: (context, index) {
                      final product = category.products[index];

                      return MenuProductItem(
                        product: product,
                        onTap: () {
                          onProductTap?.call(product);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
