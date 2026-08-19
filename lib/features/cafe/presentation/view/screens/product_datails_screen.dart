import 'package:flutter/material.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/product_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/product_datails/product_add_ons_widget.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/product_datails/product_bottom_bar_widget.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/product_datails/product_header_widget.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/product_datails/product_option_selector_widget.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/product_datails/similar_products_widget.dart';

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
      backgroundColor: Color(0xFFFFFBF8),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ProductHeaderWidget(
                  imageUrl: widget.product.image,
                  onBackPressed: () => Navigator.pop(context),
                  onFavoritePressed: () {},
                ),
                Transform.translate(
                  offset: Offset(0, -20),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
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
                              '${widget.product.price.toInt()} ج.م',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8D6654),
                              ),
                            ),
                            Text(
                              widget.product.name,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D2521),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
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
                          SizedBox(height: 20),
                        ],
                        ProductOptionSelectorWidget(
                          title: 'الحجم',
                          options: ['كبير', 'وسط', 'صغير'],
                          selectedOption: selectedSize,
                          onOptionSelected: (val) =>
                              setState(() => selectedSize = val),
                        ),
                        SizedBox(height: 20),
                        ProductOptionSelectorWidget(
                          title: 'نوع الحليب',
                          options: ['لوز', 'شوفان', 'حليب بقري'],
                          selectedOption: selectedMilk,
                          onOptionSelected: (val) =>
                              setState(() => selectedMilk = val),
                        ),
                        SizedBox(height: 20),
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
              onAddToCart: () {},
            ),
          ),
        ],
      ),
    );
  }
}
