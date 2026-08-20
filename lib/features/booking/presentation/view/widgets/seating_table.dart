import 'package:flutter/material.dart';

class SeatingTable extends StatelessWidget {
  final String id;
  final bool selected;
  final bool booked;
  final bool rectangle;
  final double size;
  final VoidCallback onTap;

  const SeatingTable({
    super.key,
    required this.id,
    required this.selected,
    required this.booked,
    required this.onTap,
    this.rectangle = false,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor = booked
        ? Colors.grey.shade300
        : selected
        ? Color(0xFF6E4027)
        : Color(0xFFE0D7D0);

    final Color backgroundColor = booked
        ? Color(0xFFE8E4E1)
        : selected
        ? Color(0xFF6E4027)
        : Colors.white;

    return GestureDetector(
      onTap: booked ? null : onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 180),
        width: rectangle ? size * 1.35 : size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: rectangle ? BoxShape.rectangle : BoxShape.circle,
          borderRadius: rectangle ? BorderRadius.circular(10) : null,
          border: Border.all(color: borderColor, width: selected ? 2 : 1),
          boxShadow: [
            if (!booked)
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 5),
          ],
        ),
        child: Center(
          child: Text(
            id,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: booked
                  ? Colors.grey
                  : selected
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
