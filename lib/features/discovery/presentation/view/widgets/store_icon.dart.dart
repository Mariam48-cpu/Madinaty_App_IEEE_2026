import 'package:flutter/material.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';

class StoreIcon extends StatelessWidget {
  const StoreIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      width: double.infinity,
      color: AppColors.surfaceVariant,
      child: const Icon(
        Icons.storefront,
        size: 45,
        color: AppColors.primary,
      ),
    );
  }
}