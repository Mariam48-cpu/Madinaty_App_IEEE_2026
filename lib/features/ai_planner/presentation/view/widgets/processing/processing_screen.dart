import 'package:flutter/material.dart';
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
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
                      colors: [Color(0xFF8B5E3C), Color(0xFFC18A61)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x338B5E3C),
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

              const Text(
                'بجهزلك يومك المثالي ✨',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2E241F),
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
                    color: Color(0xFF82756D),
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              ProcessingSteps(processingStep: processingStep),

              const SizedBox(height: 30),

              const Text(
                'بستخدم الأماكن الحقيقية القريبة منك وتفضيلاتك وحالة الجو النهارده.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF82756D),
                  fontSize: 11,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
