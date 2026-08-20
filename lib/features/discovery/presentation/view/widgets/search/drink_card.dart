import 'package:flutter/material.dart';

class DrinkCard extends StatelessWidget {
  final String name;
  final IconData icon;

 const DrinkCard({super.key, required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105,
      margin: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: Color(0xFFF4ECE8),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Color(0xFF8D6654), size: 28),
          ),

          SizedBox(height: 8),

          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
