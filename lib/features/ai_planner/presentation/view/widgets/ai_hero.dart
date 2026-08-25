import 'package:flutter/material.dart';

class AIHero extends StatelessWidget {
  final AnimationController animationController;

  const AIHero({
    super.key,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: animationController.value * 0.12,
                child: child,
              );
            },
            child: Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(23),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF8B5E3C),
                    Color(0xFFC18A61),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x388B5E3C),
                    blurRadius: 25,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'Madinaty AI',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2E241F),
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            'سيب التخطيط عليّا 🤍',
            style: TextStyle(
              color: Color(0xFF82756D),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}