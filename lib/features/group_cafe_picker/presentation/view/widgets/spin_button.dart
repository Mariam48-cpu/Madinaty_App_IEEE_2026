import 'package:flutter/material.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';

class SpinButton extends StatelessWidget {
  final bool isSpinning;
  final VoidCallback? onPressed;

  const SpinButton({
    super.key,
    required this.isSpinning,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        8,
        20,
        22,
      ),
      child: GestureDetector(
        onTap: isSpinning ? null : onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            color: isSpinning
                ? Colors.grey
                : AppColors.primary,
            borderRadius: BorderRadius.circular(18),
            boxShadow: isSpinning
                ? []
                : [
                    BoxShadow(
                      color: AppColors.primary.withValues(
                        alpha: 0.28,
                      ),
                      blurRadius: 14,
                      offset: const Offset(0, 7),
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSpinning
                    ? Icons.hourglass_top_rounded
                    : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 25,
              ),

              const SizedBox(width: 8),

              Text(
                isSpinning
                    ? 'Spinning...'
                    : 'SPIN THE WHEEL',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}