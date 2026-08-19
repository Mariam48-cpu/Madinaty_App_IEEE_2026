import 'package:flutter/material.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/product_entity.dart';

class SimilarProductsWidget extends StatelessWidget {
  final List<ProductEntity> similarProducts;
  final void Function(ProductEntity product)? onProductTap;

  const SimilarProductsWidget({
    super.key,
    required this.similarProducts,
    this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    if (similarProducts.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(height: 20),
        Text(
          'ممكن يعجبك كمان',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D2521),
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            reverse: true,
            itemCount: similarProducts.length,
            separatorBuilder: (_, __) => SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = similarProducts[index];
              return GestureDetector(
                onTap: () => onProductTap?.call(item),
                child: Container(
                  width: 130,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.network(
                          item.image,
                          height: 80,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.add_circle,
                                  color: Color(0xFF8D6654),
                                  size: 20,
                                ),
                                Text(
                                  '${item.price.toInt()} ج.م',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF8D6654),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
