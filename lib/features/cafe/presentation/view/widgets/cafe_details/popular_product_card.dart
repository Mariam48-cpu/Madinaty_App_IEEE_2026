import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';

import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/product_entity.dart';

class PopularProductCard extends StatefulWidget {
  final ProductEntity product;
  final VoidCallback? onTap;

  const PopularProductCard({super.key, required this.product, this.onTap});

  @override
  State<PopularProductCard> createState() => _PopularProductCardState();
}

class _PopularProductCardState extends State<PopularProductCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 145,
        margin: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              child: SizedBox(
                width: double.infinity,
                height: 85,
                child: widget.product.image.isNotEmpty
                    ? Image.network(
                        widget.product.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return Container(
                            color: const Color(0xFFF3EAE5),
                            child: const Center(
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
                        color: const Color(0xFFF3EAE5),
                        child: const Center(
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
              padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name.isNotEmpty
                        ? widget.product.name
                        : AppLocale.defaultProductFallback.getString(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '${widget.product.price.toStringAsFixed(0)} ${AppLocale.egpCurrency.getString(context)}',
                    style: const TextStyle(
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
