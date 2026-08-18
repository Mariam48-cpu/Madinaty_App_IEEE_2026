import 'package:flutter/material.dart';

class ProductAddOnsWidget extends StatelessWidget {
  final Map<String, Map<String, dynamic>> addOns;
  final Function(String key, bool value) onAddOnChanged;

  const ProductAddOnsWidget({
    super.key,
    required this.addOns,
    required this.onAddOnChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'إضافات',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D2521),
          ),
        ),
        SizedBox(height: 10),
        ...addOns.keys.map((title) {
          final isSelected = addOns[title]!['selected'] as bool;
          final price = addOns[title]!['price'] as double;

          return GestureDetector(
            onTap: () {
              onAddOnChanged(title, !isSelected);
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFFFFF7F2) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Color(0xFF8D6654) : Colors.grey.shade300,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '+${price.toInt()} ج.م',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Checkbox(
                        value: isSelected,
                        activeColor: Color(0xFF8D6654),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        onChanged: (val) {
                          onAddOnChanged(title, val ?? false);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
