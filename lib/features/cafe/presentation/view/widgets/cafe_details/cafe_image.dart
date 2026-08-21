import 'package:flutter/material.dart';

import 'circle_button.dart';

class CafeImage extends StatelessWidget {
  final List<String> photos;
  final VoidCallback? onBack;
  final VoidCallback? onFavorite;
  final VoidCallback? onShare;
  final bool isFavorite;

  const CafeImage({
    super.key,
    required this.photos,
    this.onBack,
    this.onFavorite,
    this.onShare,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 285,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (photos.isNotEmpty && photos.first.isNotEmpty)
            Image.network(
              photos.first,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  color: const Color(0xFFE8E0DC),
                  child: const Center(
                    child: Icon(
                      Icons.local_cafe,
                      size: 75,
                      color: Color(0xFF8D6654),
                    ),
                  ),
                );
              },
            )
          else
            Container(
              color: const Color(0xFFE8E0DC),
              child: const Center(
                child: Icon(
                  Icons.local_cafe,
                  size: 75,
                  color: Color(0xFF8D6654),
                ),
              ),
            ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 90,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.25), Colors.transparent],
                ),
              ),
            ),
          ),

          Positioned(
            top: 14,
            left: 14,
            child: Row(
              children: [
                CircleButton(
                  icon: isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  iconColor: isFavorite ? const Color(0xFF8D6654) : null,
                  onTap: onFavorite ?? () {},
                ),
                const SizedBox(width: 8),
                CircleButton(
                  icon: Icons.share_outlined,
                  onTap: onShare ?? () {},
                ),
              ],
            ),
          ),

          Positioned(
            top: 14,
            right: 14,
            child: CircleButton(
              icon: Icons.arrow_forward,
              onTap: onBack ?? () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
