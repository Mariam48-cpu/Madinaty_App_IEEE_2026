import 'package:flutter/material.dart';

class ProductHeaderWidget extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onBackPressed;
  final VoidCallback onFavoritePressed;

  const ProductHeaderWidget({
    super.key,
    required this.imageUrl,
    required this.onBackPressed,
    required this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          imageUrl,
          height: 280,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            height: 280,
            color:  Color(0xFFF7F4F2),
            child:  Icon(Icons.fastfood, size: 50, color: Colors.grey),
          ),
        ),
        SafeArea(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: onBackPressed,
                  child: Container(
                    padding:  EdgeInsets.all(8),
                    decoration:  BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color:  Color(0xFF2D2521),
                    ),
                  ),
                ),
                InkWell(
                  onTap: onFavoritePressed,
                  child: Container(
                    padding:  EdgeInsets.all(8),
                    decoration:  BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      size: 18,
                      color:  Color(0xFF2D2521),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
