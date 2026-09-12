import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/domain/entities/group_cafe_entity.dart';

import 'picked_by_section.dart';
import 'winner_card.dart';

class CompletedGroupView extends StatelessWidget {
  final GroupCafePickEntity winner;
  final List<String> pickedBy;
  final ConfettiController confettiController;

  const CompletedGroupView({
    super.key,
    required this.winner,
    required this.pickedBy,
    required this.confettiController,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 25),

              const Text(
                '🎉',
                style: TextStyle(fontSize: 55),
              ),

              const SizedBox(height: 8),

              const Text(
                'The Winner!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Your group is going to...',
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
              ),

              const SizedBox(height: 22),

              WinnerCard(
                winner: winner,
                pickedBy: pickedBy,
                imageHeight: 230,
                showPickedBy: false,
              ),

              const SizedBox(height: 25),

              PickedBySection(
                names: pickedBy,
                compact: false,
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Back to Group',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality:
                  BlastDirectionality.explosive,
              emissionFrequency: 0.03,
              numberOfParticles: 7,
              maxBlastForce: 25,
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
        ),
      ],
    );
  }
}
