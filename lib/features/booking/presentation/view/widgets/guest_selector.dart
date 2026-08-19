import 'package:flutter/material.dart';

class NewGuestSelector extends StatelessWidget {
  final int guests;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const NewGuestSelector({
    super.key,
    required this.guests,
    required this.onAdd,
    required this.onRemove,
  });

  static  Color primaryColor = Color(0xFF6E4027);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding:  EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color:  Color(0xFFE2D9D2)),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color:  Color(0xFFF2E9E2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.remove, color:  Color(0xFF6E4027)),
            ),
          ),

          Expanded(
            child: Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$guests',
                      style:  TextStyle(
                        color: primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: guests == 1 ? ' شخص' : ' أشخاص',
                      style:  TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          InkWell(
            onTap: onAdd,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color:  Color(0xFFF2E9E2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.add, color:  Color(0xFF6E4027)),
            ),
          ),
        ],
      ),
    );
  }
}
