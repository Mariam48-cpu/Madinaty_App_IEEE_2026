import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_confetti_master/flutter_confetti_master.dart'
    as balloon_confetti;
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/domain/entities/group_cafe_entity.dart';
import 'winner_card.dart';

class WinnerBottomSheet extends StatelessWidget {
  final GroupCafePickEntity winner;
  final List<String> pickedBy;
  final ConfettiController confettiController;
  final Animation<double> winnerScaleAnimation;

  const WinnerBottomSheet({
    super.key,
    required this.winner,
    required this.pickedBy,
    required this.confettiController,
    required this.winnerScaleAnimation,
  });

  static Future<void> show({
    required BuildContext context,
    required GroupCafePickEntity winner,
    required List<String> pickedBy,
    required ConfettiController confettiController,
    required Animation<double> winnerScaleAnimation,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (sheetContext) {
        return WinnerBottomSheet(
          winner: winner,
          pickedBy: pickedBy,
          confettiController: confettiController,
          winnerScaleAnimation: winnerScaleAnimation,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: IgnorePointer(
            ignoring: false,
            child: balloon_confetti.ConfettiMaster(
              effect: balloon_confetti.ConfettiEffect.balloonBurst,
              particleCount: 8,
              autoPlay: true,
              duration: const Duration(seconds: 6),
              colors: const [
                Color(0xFFFFC857),
                Color(0xFFFF8FB1),
                Color(0xFF70C7C5),
                Color(0xFF8EA7FF),
                Color(0xFFB982FF),
              ],
              options: const balloon_confetti.ConfettiOptions(
                gravity: 0.10,
                minVelocity: 1.0,
                maxVelocity: 2.0,
                minScale: 0.75,
                maxScale: 1.15,
                particleCount: 8,
                loop: false,
              ),
            ),
          ),
        ),
        Positioned(
          left: -20,
          top: 0,
          bottom: 250,
          child: ConfettiWidget(
            confettiController: confettiController,
            blastDirectionality: BlastDirectionality.directional,
            blastDirection: 0,
            emissionFrequency: 0.05,
            numberOfParticles: 5,
            maxBlastForce: 30,
            minBlastForce: 10,
            gravity: 0.25,
            shouldLoop: false,
            colors: const [
              Color(0xFFFFC857),
              Color(0xFFFF8FB1),
              Color(0xFF70C7C5),
              Color(0xFF8EA7FF),
              Color(0xFFB982FF),
            ],
          ),
        ),

        Positioned(
          right: -20,
          top: 0,
          bottom: 250,
          child: ConfettiWidget(
            confettiController: confettiController,
            blastDirectionality: BlastDirectionality.directional,
            blastDirection: pi,
            emissionFrequency: 0.05,
            numberOfParticles: 5,
            maxBlastForce: 30,
            minBlastForce: 10,
            gravity: 0.25,
            shouldLoop: false,
            colors: const [
              Color(0xFFFFC857),
              Color(0xFFFF8FB1),
              Color(0xFF70C7C5),
              Color(0xFF8EA7FF),
              Color(0xFFB982FF),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.82,
          ),
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 28),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 45,
                    height: 5,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outline.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 18),
                  ScaleTransition(
                    scale: winnerScaleAnimation,
                    child: Column(
                      children: [
                        const Text('🎉', style: TextStyle(fontSize: 48)),

                        const SizedBox(height: 5),

                        const Text(
                          'We Have a Winner!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          'Your group is going to...',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  WinnerCard(
                    winner: winner,
                    pickedBy: pickedBy,
                    imageHeight: 185,
                    showPickedBy: true,
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        "Let's Go! ☕",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
