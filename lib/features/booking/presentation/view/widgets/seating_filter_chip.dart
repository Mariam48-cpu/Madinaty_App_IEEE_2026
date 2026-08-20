import 'package:flutter/material.dart';

class SeatingFilterChip extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const SeatingFilterChip({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Color(0xFF6E4027) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? Color(0xFF6E4027) : Color(0xFFE1D8D1),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: selected ? Colors.white : Colors.black87,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
