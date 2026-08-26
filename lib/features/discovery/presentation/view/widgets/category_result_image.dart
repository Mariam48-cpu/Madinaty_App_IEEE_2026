import 'package:flutter/material.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
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
        decoration: const BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child: const Center(
          child: Icon(Icons.local_cafe, size: 60, color: AppColors.primary),
        ),
      );
    }

    final imageUrl = cafe.photos.first.trim();

    if (imageUrl.isEmpty) {
      return Container(
        height: 185,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child: const Center(
          child: Icon(Icons.local_cafe, size: 60, color: AppColors.primary),
        ),
      );
    }

    final url = Uri.tryParse(imageUrl);

    if (url == null || (url.scheme != 'http' && url.scheme != 'https')) {
      return Container(
        height: 185,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child: const Center(
          child: Icon(Icons.local_cafe, size: 60, color: AppColors.primary),
        ),
      );
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
              return Container(
                height: 185,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                ),
                child: const Center(
                  child: Icon(
                    Icons.local_cafe,
                    size: 60,
                    color: AppColors.primary,
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
                color: AppColors.surfaceVariant,
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              );
            },
          ),
        ),
        PositionedDirectional(
          top: 12,
          end: 12,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bookmark_border,
              size: 23,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (cafe.rating > 0)
          PositionedDirectional(
            start: 10,
            bottom: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.surface,
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
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 3),
                  const Icon(Icons.star, size: 13, color: Colors.amber),
                ],
              ),
            ),
          ),
      ],
    );
  }
}