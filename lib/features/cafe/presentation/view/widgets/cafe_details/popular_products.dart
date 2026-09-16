import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/cafe_experience_entity.dart';

import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/menu_category_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/product_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/screens/cafe_menu_screen.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/screens/product_datails_screen.dart';
import 'popular_product_card.dart';

class PopularProducts extends StatelessWidget {
  final List<MenuCategoryEntity> menu;
  final CafeExperienceEntity experience;
  final void Function(ProductEntity product)? onProductTap;
  const PopularProducts({
    super.key,
    required this.menu,
    required this.experience,
    this.onProductTap,
  });
  @override
  Widget build(BuildContext context) {
    final products = menu
        .expand((category) => category.products)
        .take(6)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocale.mostOrdered.getString(context),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D2521),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CafeMenuScreen(
                      categories: menu,
                      experience: experience,
                    ),
                  ),
                );
              },
              child: Text(
                AppLocale.viewMenu.getString(context),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8D6654),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailsScreen(product: product),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
