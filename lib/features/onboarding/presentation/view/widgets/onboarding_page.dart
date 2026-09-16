import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';

import '../../../domain/entities/onboarding_entity.dart';

class OnboardingPage extends StatefulWidget {
  final OnboardingEntity page;

  const OnboardingPage({super.key, required this.page});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatingController;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SizedBox(
          height: screenHeight * 0.48,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AnimatedBuilder(
              animation: _floatingController,
              builder: (context, child) {
                final floatingOffset = Tween<double>(
                  begin: -4,
                  end: 4,
                ).transform(_floatingController.value);

                return Transform.translate(
                  offset: Offset(0, floatingOffset),
                  child: child,
                );
              },
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: SizedBox(
                    height: screenHeight * 0.44,
                    width: double.infinity,
                    child: Image.asset(
                      widget.page.image,
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            widget.page.title.getString(context),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
        ),

        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            widget.page.description.getString(context),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

