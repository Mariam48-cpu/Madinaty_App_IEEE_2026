import 'package:flutter/material.dart';

class CafeMenuHeader extends StatelessWidget {
  final String cafeName;
  final VoidCallback onBackPressed;

  const CafeMenuHeader({
    super.key,
    required this.cafeName,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.search, color: Color(0xFF2D2521), size: 24),
            onPressed: () {},
          ),

          Column(
            children: [
              Text(
                cafeName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2521),
                ),
              ),
              Text(
                'القهوة المختصة',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),

          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF2D2521),
              size: 20,
            ),
            onPressed: onBackPressed,
          ),
        ],
      ),
    );
  }
}
