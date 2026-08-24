import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/di/injection.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/utils/app_toast.dart';
import 'package:madinaty_app_ieee_2026/features/cart/domain/entities/cart_item_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cart/domain/use_cases/add_to_cart_use_case.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/product_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/product_datails/product_add_ons_widget.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/product_datails/product_bottom_bar_widget.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/product_datails/product_header_widget.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/product_datails/product_option_selector_widget.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/product_datails/similar_products_widget.dart';
import 'package:madinaty_app_ieee_2026/features/favorites/domain/entities/favorite_item_entity.dart';
import 'package:madinaty_app_ieee_2026/features/favorites/domain/use_cases/is_favorite_use_case.dart';
import 'package:madinaty_app_ieee_2026/features/favorites/domain/use_cases/toggle_favorite_use_case.dart';
import 'package:toastification/toastification.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductEntity product;
  final List<ProductEntity> similarProducts;
  final void Function(ProductEntity product)? onProductTap;

  const ProductDetailsScreen({
    super.key,
    required this.product,
    this.similarProducts = const [],
    this.onProductTap,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String selectedSize = 'وسط';
  String selectedMilk = 'حليب بقري';
  int quantity = 1;
  bool _isFavorite = false;
  bool _isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    final isFav = await getIt<IsFavoriteUseCase>()(
      targetId: widget.product.id,
      type: FavoriteTargetType.product,
    );
    if (mounted) {
      setState(() => _isFavorite = isFav);
    }
  }

  Future<void> _toggleFavorite() async {
    final item = FavoriteItemEntity.fromProduct(widget.product);
    await getIt<ToggleFavoriteUseCase>()(item);
    if (mounted) {
      setState(() => _isFavorite = !_isFavorite);
    }
  }

  Future<void> _handleAddToCart() async {
    if (_isAddingToCart) return;
    setState(() => _isAddingToCart = true);

    try {
      final selectedAddOns = addOns.entries
          .where((e) => e.value['selected'] == true)
          .map((e) => e.key)
          .toList();

      final allOptions = [
        selectedSize,
        selectedMilk,
        ...selectedAddOns,
      ].where((s) => s.isNotEmpty).join(', ');

      final unitPrice = calculateTotalPrice() / quantity;
      final cartItem = CartItemEntity(
        id: '${widget.product.id}_${allOptions.hashCode.abs()}',
        title: widget.product.name,
        customOptions: allOptions.isNotEmpty ? allOptions : null,
        price: unitPrice,
        quantity: quantity,
        imageUrl: widget.product.image.isNotEmpty ? widget.product.image : null,
      );

      await getIt<AddToCartUseCase>()(cartItem);

      if (mounted) {
        AppToast.showToast(
          context: context,
          title: AppLocale.successTitle.getString(context),
          description: AppLocale.itemAddedToCart.getString(context),
          type: ToastificationType.success,
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        AppToast.showToast(
          context: context,
          title: AppLocale.toastError.getString(context),
          description: e.toString(),
          type: ToastificationType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAddingToCart = false);
      }
    }
  }

  final Map<String, Map<String, dynamic>> addOns = {
    'إكسترا شوت': {'price': 20.0, 'selected': false},
    'كراميل': {'price': 15.0, 'selected': true},
    'فانيليا': {'price': 15.0, 'selected': false},
  };
  double calculateTotalPrice() {
    double basePrice = widget.product.price;
    double addOnsPrice = 0.0;
    addOns.forEach((key, value) {
      if (value['selected'] == true) {
        addOnsPrice += (value['price'] as double);
      }
    });
    return (basePrice + addOnsPrice) * quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF8),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ProductHeaderWidget(
                  imageUrl: widget.product.image,
                  isFavorite: _isFavorite,
                  onBackPressed: () => Navigator.pop(context),
                  onFavoritePressed: _toggleFavorite,
                ),

                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFFBF8),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${widget.product.price.toInt()} ${AppLocale.currency.getString(context)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8D6654),
                              ),
                            ),
                            Text(
                              widget.product.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D2521),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        if (widget.product.description.isNotEmpty) ...[
                          Text(
                            widget.product.description,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.6,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                        ProductOptionSelectorWidget(
                          title: 'الحجم',
                          options: const ['كبير', 'وسط', 'صغير'],
                          selectedOption: selectedSize,
                          onOptionSelected: (val) =>
                              setState(() => selectedSize = val),
                        ),
                        const SizedBox(height: 20),
                        ProductOptionSelectorWidget(
                          title: 'نوع الحليب',
                          options: const ['لوز', 'شوفان', 'حليب بقري'],
                          selectedOption: selectedMilk,
                          onOptionSelected: (val) =>
                              setState(() => selectedMilk = val),
                        ),
                        const SizedBox(height: 20),
                        ProductAddOnsWidget(
                          addOns: addOns,
                          onAddOnChanged: (key, val) {
                            setState(() => addOns[key]!['selected'] = val);
                          },
                        ),
                        SimilarProductsWidget(
                          similarProducts: widget.similarProducts,
                          onProductTap: widget.onProductTap,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ProductBottomBarWidget(
              totalPrice: calculateTotalPrice(),
              quantity: quantity,
              onIncrement: () => setState(() => quantity++),
              onDecrement: () {
                if (quantity > 1) setState(() => quantity--);
              },
              onAddToCart: _handleAddToCart,
            ),
          ),
        ],
      ),
    );
  }
}
