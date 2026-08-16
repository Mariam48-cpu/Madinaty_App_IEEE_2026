import 'package:flutter/material.dart';

import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/product_entity.dart';

class PopularProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onTap;

  const PopularProductCard({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 145,
        margin: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              child: SizedBox(
                width: double.infinity,
                height: 85,
                child: product.image.isNotEmpty
                    ? Image.network(
                        product.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return Container(
                            color: Color(0xFFF3EAE5),
                            child: Center(
                              child: Icon(
                                Icons.coffee,
                                color: Color(0xFF8D6654),
                                size: 32,
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Color(0xFFF3EAE5),
                        child: Center(
                          child: Icon(
                            Icons.coffee,
                            color: Color(0xFF8D6654),
                            size: 32,
                          ),
                        ),
                      ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(8, 7, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    product.name,
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 4),

                  Text(
                    '${product.price.toStringAsFixed(0)} ج.م',
                    style: TextStyle(
                      color: Color(0xFF8D6654),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
