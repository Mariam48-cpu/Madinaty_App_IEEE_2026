import 'package:flutter/material.dart';

class RecentSearchItem extends StatelessWidget {
  final String search;
  final VoidCallback onSelected;
  final VoidCallback onRemoved;

  const RecentSearchItem({
    required this.search,
    required this.onSelected,
    required this.onRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Color(0xFFF4ECE8),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onRemoved,
            child: Icon(Icons.close, size: 15, color: Colors.grey),
          ),

          SizedBox(width: 5),

          GestureDetector(
            onTap: onSelected,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.history, size: 14, color: Colors.grey),

                SizedBox(width: 5),

                Text(search, style: TextStyle(fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
