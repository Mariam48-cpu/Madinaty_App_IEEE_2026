import 'package:flutter/material.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';

class AIPlannerTopBar extends StatelessWidget {
  final bool showBack;
  final VoidCallback? onBack;

  const AIPlannerTopBar({
    super.key,
    this.showBack = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBack)
          IconButton(
            onPressed: onBack ?? () => Navigator.pop(context),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.surface,
            ),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.textPrimary,
              size: 20,
            ),
          )
        else
          const SizedBox(width: 48),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: const Color(0xFFE7DDD4),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                size: 15,
                color: AppColors.primary,
              ),
              SizedBox(width: 5),
              Text(
                'Madinaty AI',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        const SizedBox(width: 48),
      ],
    );
  }
}