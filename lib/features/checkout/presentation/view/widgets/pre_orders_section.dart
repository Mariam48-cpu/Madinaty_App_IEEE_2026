import 'package:flutter/material.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_typography.dart';
import '../../../../cart/domain/entities/cart_item_entity.dart';

class PreOrdersSection extends StatelessWidget {
  final List<CartItemEntity> preOrderItems;
  final Function(String itemId, int newQuantity) onQuantityChanged;
  final VoidCallback? onEditPressed;

  const PreOrdersSection({
    super.key,
    required this.preOrderItems,
    required this.onQuantityChanged,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (preOrderItems.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('الطلبات المسبقة', style: AppTypography.titleLarge),
            if (onEditPressed != null)
              GestureDetector(
                onTap: onEditPressed,
                child: Text(
                  'تعديل',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: preOrderItems.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final item = preOrderItems[index];
            return _buildPreOrderItemCard(item);
          },
        ),
      ],
    );
  }

  Widget _buildPreOrderItemCard(CartItemEntity item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCounterButton(
                  icon: Icons.remove,
                  onTap: () => onQuantityChanged(item.id, item.quantity - 1),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '${item.quantity}',
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                _buildCounterButton(
                  icon: Icons.add,
                  onTap: () => onQuantityChanged(item.id, item.quantity + 1),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTypography.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.customOptions != null &&
                    item.customOptions!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.customOptions!,
                    style: AppTypography.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  '${item.totalPrice.toStringAsFixed(0)} ج.م',
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                ? Image.network(
                    item.imageUrl!,
                    width: 55,
                    height: 55,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _buildPlaceholderImage(),
                  )
                : _buildPlaceholderImage(),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 14, color: AppColors.primary),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 55,
      height: 55,
      color: AppColors.surfaceVariant,
      child: const Icon(Icons.coffee, color: AppColors.primary, size: 24),
    );
  }
}
