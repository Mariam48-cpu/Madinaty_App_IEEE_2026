import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/features/ai_planner/presentation/view/widgets/processing/processing_steps.dart';

class ProcessingScreen extends StatelessWidget {
  final AnimationController animationController;
  final int processingStep;
  final List<String> processingMessages;

  const ProcessingScreen({
    super.key,
    required this.animationController,
    required this.processingStep,
    required this.processingMessages,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('processing'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1 + (animationController.value * .08),
                  child: child,
                );
              },
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, Color(0xFFC18A61)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 35,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 42,
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              AppLocale.aiProcessingTitle.getString(context),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Text(
                processingMessages[processingStep],
                key: ValueKey(processingStep),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 35),
            ProcessingSteps(processingStep: processingStep),
            const SizedBox(height: 30),
            Text(
              AppLocale.aiProcessingFooterHint.getString(context),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}