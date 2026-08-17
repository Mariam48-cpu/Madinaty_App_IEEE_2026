import 'package:flutter/material.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/product_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/cafe_menu/quantity_control.dart';

class RegularProductMenuCard extends StatelessWidget {
  final ProductEntity product;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const RegularProductMenuCard({
    super.key,
    required this.product,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          QuantityControl(
            quantity: quantity,
            onAdd: onAdd,
            onRemove: onRemove,
            backgroundColor: const Color(0xFFFFF0E6),
            iconColor: const Color(0xFF8D6654),
            textColor: const Color(0xFF8D6654),
          ),
          SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2521),
                  ),
                ),

                SizedBox(height: 2),

                Text(
                  product.description,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),

                SizedBox(height: 6),

                Text(
                  '${product.price.toInt()} ج.م',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2521),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 12),

          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              product.image,
              height: 65,
              width: 65,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 65,
                width: 65,
                color: Colors.grey.shade200,
                child: Icon(Icons.coffee, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
