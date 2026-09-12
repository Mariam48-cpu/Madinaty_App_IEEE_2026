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
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _floatingController;

  late final Animation<double> _imageFade;
  late final Animation<double> _imageScale;

  late final Animation<Offset> _textSlide;
  late final Animation<double> _textFade;

  late final Animation<Offset> _descriptionSlide;
  late final Animation<double> _descriptionFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _imageFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
    );

    _imageScale = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.60, curve: Curves.easeOutBack),
      ),
    );

    _textSlide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.25, 0.70, curve: Curves.easeOutCubic),
          ),
        );

    _textFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 0.65, curve: Curves.easeOut),
    );

    _descriptionSlide =
        Tween<Offset>(begin: const Offset(0, 0.20), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.45, 0.90, curve: Curves.easeOutCubic),
          ),
        );

    _descriptionFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.45, 0.90, curve: Curves.easeOut),
    );

    _controller.forward();
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (mounted) {
        _floatingController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SizedBox(
          height: screenHeight * 0.52,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: FadeTransition(
              opacity: _imageFade,
              child: ScaleTransition(
                scale: _imageScale,
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      widget.page.image,
                      width: double.infinity,
                      height: screenHeight * 0.50,
                      fit: BoxFit.contain,
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
          child: SlideTransition(
            position: _textSlide,
            child: FadeTransition(
              opacity: _textFade,
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
          ),
        ),

        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SlideTransition(
            position: _descriptionSlide,
            child: FadeTransition(
              opacity: _descriptionFade,
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
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
