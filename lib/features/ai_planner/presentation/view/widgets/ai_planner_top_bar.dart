import 'package:flutter/material.dart';

class AIPlannerTopBar extends StatelessWidget {
  final bool showBack;
  final VoidCallback? onBack;

  const AIPlannerTopBar({
    super.key,
    this.showBack = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBack)
          IconButton(
            onPressed: onBack ?? () => Navigator.pop(context),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
            ),
            icon: const Icon(
              Icons.arrow_forward_rounded,
              color: Color(0xFF2E241F),
              size: 20,
            ),
          )
        else
          const SizedBox(width: 48),

        const Spacer(),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: Color(0xFFE7DDD4),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                size: 15,
                color: Color(0xFF8B5E3C),
              ),
              SizedBox(width: 5),
              Text(
                'Madinaty AI',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E241F),
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        const SizedBox(width: 48),
      ],
    );
  }
}