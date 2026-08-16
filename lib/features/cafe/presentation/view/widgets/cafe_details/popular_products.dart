import 'package:flutter/material.dart';

import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/menu_category_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/product_entity.dart';
import 'popular_product_card.dart';

class PopularProducts extends StatelessWidget {
  final List<MenuCategoryEntity> menu;
  final void Function(ProductEntity product)? onProductTap;
  const PopularProducts({super.key, required this.menu, this.onProductTap});

  @override
  Widget build(BuildContext context) {
    final products = menu
        .expand((category) => category.products)
        .take(6)
        .toList();

    if (products.isEmpty) {
      return  SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
         Text(
          'الأكثر طلبًا',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D2521),
          ),
        ),

         SizedBox(height: 12),

        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            reverse: true,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return PopularProductCard(
                product: product,
                onTap: () {
                  onProductTap?.call(product);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
