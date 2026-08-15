import 'package:flutter/material.dart';

import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

class CategoryResultImage extends StatelessWidget {
  final CafeEntity cafe;

  const CategoryResultImage({super.key, required this.cafe});

  @override
  Widget build(BuildContext context) {
    if (cafe.photos.isEmpty) {
      return CupPhoto();
    }

    final imageUrl = cafe.photos.first.trim();

    if (imageUrl.isEmpty) {
      return CupPhoto();
    }

    final uri = Uri.tryParse(imageUrl);

    if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
      return CupPhoto();
    }
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          child: Image.network(
            imageUrl,
            height: 185,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return CupPhoto();
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Container(
                height: 185,
                width: double.infinity,
                color: const Color(0xFFE8E0DC),
                child: const Center(
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
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
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
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    cafe.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3D332E),
                    ),
                  ),
                  const SizedBox(width: 3),
                  const Icon(Icons.star, size: 13, color: Color(0xFF8D5F35)),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget CupPhoto() {
    return Container(
      height: 185,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFE8E0DC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: const Center(
        child: Icon(Icons.local_cafe, size: 60, color: Color(0xFF8D6654)),
      ),
    );
  }
}
