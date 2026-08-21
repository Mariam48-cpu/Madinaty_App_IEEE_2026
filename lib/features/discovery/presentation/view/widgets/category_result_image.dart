import 'package:flutter/material.dart';

import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

class CategoryResultImage extends StatelessWidget {
  final CafeEntity cafe;

  const CategoryResultImage({super.key, required this.cafe});

  @override
  Widget build(BuildContext context) {
    if (cafe.photos.isEmpty) {
      return Container(
        height: 185,
        width: double.infinity,
        decoration:  BoxDecoration(
          color: Color(0xFFE8E0DC),
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child:  Center(
          child: Icon(Icons.local_cafe, size: 60, color: Color(0xFF8D6654)),
        ),
      );
    }

    final imageUrl = cafe.photos.first.trim();

    if (imageUrl.isEmpty) {
      return Container(
        height: 185,
        width: double.infinity,
        decoration:  BoxDecoration(
          color: Color(0xFFE8E0DC),
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child:  Center(
          child: Icon(Icons.local_cafe, size: 60, color: Color(0xFF8D6654)),
        ),
      );
    }

    final url = Uri.tryParse(imageUrl);

    if (url == null || (url.scheme != 'http' && url.scheme != 'https')) {
      return Container(
        height: 185,
        width: double.infinity,
        decoration:  BoxDecoration(
          color: Color(0xFFE8E0DC),
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child:  Center(
          child: Icon(Icons.local_cafe, size: 60, color: Color(0xFF8D6654)),
        ),
      );
    }
    return Stack(
      children: [
        ClipRRect(
          borderRadius:  BorderRadius.vertical(top: Radius.circular(18)),
          child: Image.network(
            imageUrl,
            height: 185,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return Container(
                height: 185,
                width: double.infinity,
                decoration:  BoxDecoration(
                  color: Color(0xFFE8E0DC),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                ),
                child:  Center(
                  child: Icon(
                    Icons.local_cafe,
                    size: 60,
                    color: Color(0xFF8D6654),
                  ),
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Container(
                height: 185,
                width: double.infinity,
                color:  Color(0xFFE8E0DC),
                child:  Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            width: 40,
            height: 40,
            decoration:  BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child:  Icon(
              Icons.bookmark_border,
              size: 23,
              color: Color(0xFF3D332E),
            ),
          ),
        ),
        if (cafe.rating > 0)
          Positioned(
            left: 10,
            bottom: 10,
            child: Container(
              padding:  EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    cafe.rating.toStringAsFixed(1),
                    style:  TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3D332E),
                    ),
                  ),
                   SizedBox(width: 3),
                   Icon(Icons.star, size: 13, color: Color(0xFF8D5F35)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
