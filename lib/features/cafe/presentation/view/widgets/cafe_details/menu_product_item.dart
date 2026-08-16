import 'package:flutter/material.dart';

import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/product_entity.dart';

class MenuProductItem extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onTap;

  const MenuProductItem({super.key, required this.product, this.onTap});

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
          border: Border.all(color: Color(0xFFF0E5DF)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              child: SizedBox(
                height: 82,
                width: double.infinity,
                child: product.image.isNotEmpty
                    ? Image.network(
                        product.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return Container(
                            color: Color(0xFFF3EAE5),
                            child: Center(
                              child: Icon(
                                Icons.local_cafe,
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
                            Icons.local_cafe,
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
                    product.name.isNotEmpty ? product.name : 'منتج',
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
