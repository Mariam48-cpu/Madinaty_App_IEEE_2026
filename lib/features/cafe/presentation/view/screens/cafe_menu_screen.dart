import 'package:flutter/material.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/cafe_experience_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/menu_category_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/product_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/screens/product_datails_screen.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/cafe_menu/cafe_menu_header.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/cafe_menu/cart_bottom_bar.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/cafe_menu/menu_category_chips.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/cafe_menu/regular_product_menu_card.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/cafe_menu/popular_product_menu_card.dart';

class CafeMenuScreen extends StatefulWidget {
  final CafeExperienceEntity experience;

  const CafeMenuScreen({
    super.key,
    required this.experience,
    required List<MenuCategoryEntity> categories,
  });

  @override
  State<CafeMenuScreen> createState() => _CafeMenuScreenState();
}

class _CafeMenuScreenState extends State<CafeMenuScreen> {
  String selectedCategoryId = 'all';

  final List<ProductEntity> cartItems = [];

  List<ProductEntity> allProducts() {
    return widget.experience.menu
        .expand((category) => category.products)
        .toList();
  }

  List<ProductEntity> filteredProducts() {
    if (selectedCategoryId == 'all') {
      return allProducts();
    }

    return widget.experience.menu
        .firstWhere(
          (category) => category.id == selectedCategoryId,
          orElse: () =>
              MenuCategoryEntity(id: '', cafeId: '', name: '', products: []),
        )
        .products;
  }

  List<ProductEntity> popularProducts() {
    return filteredProducts().take(2).toList();
  }

  List<ProductEntity> regularProducts() {
    return filteredProducts().skip(2).toList();
  }

  double totalPrice() {
    return cartItems.fold(0, (sum, item) => sum + item.price);
  }

  void addToCart(ProductEntity product) {
    setState(() {
      cartItems.add(product);
    });
  }

  void removeFromCart(ProductEntity product) {
    setState(() {
      cartItems.remove(product);
    });
  }

  int getProductQuantity(ProductEntity product) {
    return cartItems.where((item) => item.id == product.id).length;
  }

  void selectCategory(String categoryId) {
    setState(() {
      selectedCategoryId = categoryId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF9F6),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                CafeMenuHeader(
                  cafeName: widget.experience.cafe.name,
                  onBackPressed: () {
                    Navigator.pop(context);
                  },
                ),

                MenuCategoryChips(
                  categories: widget.experience.menu,
                  selectedCategoryId: selectedCategoryId,
                  onCategorySelected: selectCategory,
                ),

                SizedBox(height: 12),

                Expanded(
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 100),
                    children: [
                      if (popularProducts().isNotEmpty) ...[
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'الأكثر مبيعاً',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D2521),
                            ),
                          ),
                        ),

                        SizedBox(height: 12),

                        ...popularProducts().map(
                          (product) => PopularProductMenuCard(
                            product: product,
                            quantity: getProductQuantity(product),
                            onAdd: () => addToCart(product),
                            onRemove: () => removeFromCart(product),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetailsScreen(product: product),
                                ),
                              );
                            },
                          ),
                        ),

                        SizedBox(height: 20),
                      ],

                      if (regularProducts().isNotEmpty) ...[
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'المشروبات والحلويات',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D2521),
                            ),
                          ),
                        ),

                        SizedBox(height: 12),

                        ...regularProducts().map(
                          (product) => RegularProductMenuCard(
                            product: product,
                            quantity: getProductQuantity(product),
                            onAdd: () => addToCart(product),
                            onRemove: () => removeFromCart(product),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetailsScreen(product: product),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (cartItems.isNotEmpty)
              CartBottomBar(
                itemCount: cartItems.length,
                totalPrice: totalPrice(),
              ),
          ],
        ),
      ),
    );
  }
}
