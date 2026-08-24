import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_typography.dart';

class PreOrderBottomBar extends StatelessWidget {
  final double totalPrice;
  final int itemCount;
  final VoidCallback onProceed;
  final VoidCallback onSkip;

  const PreOrderBottomBar({
    super.key,
    required this.totalPrice,
    required this.itemCount,
    required this.onProceed,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final currency = AppLocale.currency.getString(context);
    final itemsCountText = AppLocale.itemsCount.getString(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Skip Pre-Order Button
          GestureDetector(
            onTap: onSkip,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Text(
                AppLocale.skipPreOrder.getString(context),
                style: AppTypography.bodySmall.copyWith(
                  color: const Color(0xFF8D6654),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),

          const SizedBox(height: 6),

          // Total Info & Proceed Button Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Proceed Button (Left)
              ElevatedButton(
                onPressed: onProceed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkButton,
                  foregroundColor: AppColors.onDarkButton,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.shopping_bag_outlined,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocale.proceedToCart.getString(context),
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.onDarkButton,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Estimated Total (Right)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocale.temporaryTotal.getString(context),
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '/ $itemCount $itemsCountText',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${totalPrice % 1 == 0 ? totalPrice.toInt() : totalPrice.toStringAsFixed(2)} $currency',
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
