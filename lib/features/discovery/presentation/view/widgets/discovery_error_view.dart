import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';

class DiscoveryErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const DiscoveryErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 55,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkButton,
                foregroundColor: AppColors.onDarkButton,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed: onRetry,
              child: Text(
                AppLocale.retry.getString(context),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}