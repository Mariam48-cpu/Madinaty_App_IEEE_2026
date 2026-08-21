import 'package:flutter/material.dart';

class QuantityControl extends StatelessWidget {
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final Color? borderColor;

  const QuantityControl({
    super.key,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    if (quantity == 0) {
      return InkWell(
        onTap: onAdd,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
            border: borderColor != null
                ? Border.all(color: borderColor!, width: 1)
                : null,
          ),
          child: Icon(Icons.add, color: iconColor, size: 18),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onAdd,
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.add, color: iconColor, size: 16),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              '$quantity',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),

          InkWell(
            onTap: onRemove,
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.remove, color: iconColor, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
