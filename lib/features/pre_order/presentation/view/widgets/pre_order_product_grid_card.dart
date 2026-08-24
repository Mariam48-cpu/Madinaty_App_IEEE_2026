import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/di/injection.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_typography.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/product_entity.dart';
import 'package:madinaty_app_ieee_2026/features/favorites/domain/entities/favorite_item_entity.dart';
import 'package:madinaty_app_ieee_2026/features/favorites/domain/use_cases/is_favorite_use_case.dart';
import 'package:madinaty_app_ieee_2026/features/favorites/domain/use_cases/toggle_favorite_use_case.dart';

class PreOrderProductGridCard extends StatefulWidget {
  final ProductEntity product;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const PreOrderProductGridCard({
    super.key,
    required this.product,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
    required this.onTap,
  });

  @override
  State<PreOrderProductGridCard> createState() =>
      _PreOrderProductGridCardState();
}

class _PreOrderProductGridCardState extends State<PreOrderProductGridCard> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    try {
      final isFav = await getIt<IsFavoriteUseCase>()(
        targetId: widget.product.id,
        type: FavoriteTargetType.product,
      );
      if (mounted) {
        setState(() => _isFavorite = isFav);
      }
    } catch (_) {}
  }

  Future<void> _toggleFavorite() async {
    try {
      final item = FavoriteItemEntity.fromProduct(widget.product);
      await getIt<ToggleFavoriteUseCase>()(item);
      if (mounted) {
        setState(() => _isFavorite = !_isFavorite);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final currency = AppLocale.currency.getString(context);

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image & Favorite Button
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: widget.product.image.isNotEmpty
                      ? Image.network(
                          widget.product.image,
                          height: 110,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildPlaceholderImage(),
                        )
                      : _buildPlaceholderImage(),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: _toggleFavorite,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        _isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 16,
                        color: _isFavorite
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Product Title
            Text(
              widget.product.name,
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 2),

            // Product Description
            Text(
              widget.product.description.isNotEmpty
                  ? widget.product.description
                  : 'مزيج كلاسيكي رائع وطازج',
              style: AppTypography.bodySmall.copyWith(
                fontSize: 10,
                color: AppColors.textSecondary,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const Spacer(),

            // Price and Action Button Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Price
                Text(
                  '${widget.product.price.toInt()} $currency',
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                // Counter / Add Action
                if (widget.quantity == 0)
                  GestureDetector(
                    onTap: widget.onAdd,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFF17120F),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5EBE6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: widget.onAdd,
                          child: const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Icon(
                              Icons.add,
                              size: 14,
                              color: Color(0xFF17120F),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            '${widget.quantity}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF17120F),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: widget.onRemove,
                          child: const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Icon(
                              Icons.remove,
                              size: 14,
                              color: Color(0xFF17120F),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 110,
      width: double.infinity,
      color: const Color(0xFFF5EBE6),
      child: const Icon(
        Icons.coffee_rounded,
        color: Color(0xFF8D6654),
        size: 32,
      ),
    );
  }
}
