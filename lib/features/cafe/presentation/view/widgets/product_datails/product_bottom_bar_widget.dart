import 'package:flutter/material.dart';

class ProductBottomBarWidget extends StatelessWidget {
  final double totalPrice;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onAddToCart;

  const ProductBottomBarWidget({
    super.key,
    required this.totalPrice,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF17120F),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: onAddToCart,
                child: Text(
                  'أضف للسلة (${totalPrice.toInt()} ج.م)',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xFFF7F4F2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: onIncrement,
                    child: Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Icon(
                        Icons.add,
                        size: 16,
                        color: Color(0xFF2D2521),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '$quantity',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onDecrement,
                    child: Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Icon(
                        Icons.remove,
                        size: 16,
                        color: Color(0xFF2D2521),
                      ),
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
