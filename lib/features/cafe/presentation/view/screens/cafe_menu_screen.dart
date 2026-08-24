import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madinaty_app_ieee_2026/core/di/injection.dart';
import 'package:madinaty_app_ieee_2026/core/routes/app_routes.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/cafe_experience_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/menu_category_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/product_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/screens/product_datails_screen.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/cafe_menu/cafe_menu_header.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/cafe_menu/cart_bottom_bar.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/cafe_menu/menu_category_chips.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/cafe_menu/popular_product_menu_card.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/cafe_menu/regular_product_menu_card.dart';
import 'package:madinaty_app_ieee_2026/features/cart/domain/entities/cart_item_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cart/presentation/view_model/cubit/cart_cubit.dart';
import 'package:madinaty_app_ieee_2026/features/cart/presentation/view_model/cubit/cart_state.dart';

class CafeMenuScreen extends StatelessWidget {
  final CafeExperienceEntity experience;

  const CafeMenuScreen({
    super.key,
    required this.experience,
    required List<MenuCategoryEntity> categories,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CartCubit>()
        ..initCartWatcher(cafeName: experience.cafe.name),
      child: _CafeMenuView(experience: experience),
    );
  }
}

class _CafeMenuView extends StatefulWidget {
  final CafeExperienceEntity experience;

  const _CafeMenuView({required this.experience});

  @override
  State<_CafeMenuView> createState() => _CafeMenuViewState();
}

class _CafeMenuViewState extends State<_CafeMenuView> {
  String selectedCategoryId = 'all';

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

  void selectCategory(String categoryId) {
    setState(() {
      selectedCategoryId = categoryId;
    });
  }

  int _getProductQuantity(CartState cartState, ProductEntity product) {
    if (cartState is CartLoaded) {
      return cartState.items
          .where((item) =>
              item.id == product.id || item.id.startsWith('${product.id}_'))
          .fold(0, (sum, item) => sum + item.quantity);
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F6),
      body: SafeArea(
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, cartState) {
            final hasCartItems =
                cartState is CartLoaded && !cartState.isEmpty;
            final cartItemCount =
                cartState is CartLoaded ? cartState.totalItemsCount : 0;
            final cartTotalPrice =
                cartState is CartLoaded ? cartState.subtotal : 0.0;

            return Stack(
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

                    const SizedBox(height: 12),

                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(
                          16,
                          8,
                          16,
                          hasCartItems ? 100 : 20,
                        ),
                        children: [
                          if (popularProducts().isNotEmpty) ...[
                            const Align(
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

                            const SizedBox(height: 12),

                            ...popularProducts().map(
                              (product) => PopularProductMenuCard(
                                product: product,
                                quantity:
                                    _getProductQuantity(cartState, product),
                                onAdd: () {
                                  cartCubit.addToCart(
                                    CartItemEntity(
                                      id: product.id,
                                      title: product.name,
                                      price: product.price,
                                      quantity: 1,
                                      imageUrl: product.image.isNotEmpty
                                          ? product.image
                                          : null,
                                    ),
                                  );
                                },
                                onRemove: () {
                                  if (cartState is CartLoaded) {
                                    final matchingItem =
                                        cartState.items.firstWhere(
                                      (i) =>
                                          i.id == product.id ||
                                          i.id.startsWith('${product.id}_'),
                                      orElse: () => CartItemEntity(
                                        id: product.id,
                                        title: product.name,
                                        price: product.price,
                                        quantity: 1,
                                      ),
                                    );
                                    cartCubit.decrementQuantity(matchingItem);
                                  }
                                },
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

                            const SizedBox(height: 20),
                          ],

                          if (regularProducts().isNotEmpty) ...[
                            const Align(
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

                            const SizedBox(height: 12),

                            ...regularProducts().map(
                              (product) => RegularProductMenuCard(
                                product: product,
                                quantity:
                                    _getProductQuantity(cartState, product),
                                onAdd: () {
                                  cartCubit.addToCart(
                                    CartItemEntity(
                                      id: product.id,
                                      title: product.name,
                                      price: product.price,
                                      quantity: 1,
                                      imageUrl: product.image.isNotEmpty
                                          ? product.image
                                          : null,
                                    ),
                                  );
                                },
                                onRemove: () {
                                  if (cartState is CartLoaded) {
                                    final matchingItem =
                                        cartState.items.firstWhere(
                                      (i) =>
                                          i.id == product.id ||
                                          i.id.startsWith('${product.id}_'),
                                      orElse: () => CartItemEntity(
                                        id: product.id,
                                        title: product.name,
                                        price: product.price,
                                        quantity: 1,
                                      ),
                                    );
                                    cartCubit.decrementQuantity(matchingItem);
                                  }
                                },
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
                if (hasCartItems)
                  CartBottomBar(
                    itemCount: cartItemCount,
                    totalPrice: cartTotalPrice,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.cart,
                        arguments: widget.experience.cafe.name,
                      );
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
