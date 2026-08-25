import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';

class EmptySearchState extends StatelessWidget {
  final bool hasQuery;
  final VoidCallback onShowNearby;

  const EmptySearchState({
    super.key,
    required this.hasQuery,
    required this.onShowNearby,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        const Center(
          child: Icon(
            Icons.search_off,
            size: 60,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            hasQuery
                ? AppLocale.noMatchingCafesFound.getString(context)
                : AppLocale.noNearbyCafesFound.getString(context),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 25),
        Center(
          child: OutlinedButton(
            onPressed: onShowNearby,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              AppLocale.showNearbyCafes.getString(context),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}