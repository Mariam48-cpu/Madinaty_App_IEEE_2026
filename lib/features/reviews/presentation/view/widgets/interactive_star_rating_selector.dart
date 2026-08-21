import 'package:flutter/material.dart';

class InteractiveStarRatingSelector extends StatelessWidget {
  final double currentRating;
  final ValueChanged<double> onRatingChanged;
  final double starSize;
  final Color activeColor;
  final Color inactiveColor;

  const InteractiveStarRatingSelector({
    super.key,
    required this.currentRating,
    required this.onRatingChanged,
    this.starSize = 40.0,
    this.activeColor = const Color(0xFFE69A35),
    this.inactiveColor = const Color(0xFFE5DDD5),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starValue = (index + 1).toDouble();
        final isFilled = starValue <= currentRating;

        return GestureDetector(
          onTap: () => onRatingChanged(starValue),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: AnimatedScale(
              scale: isFilled ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutBack,
              child: Icon(
                isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                size: starSize,
                color: isFilled ? activeColor : inactiveColor,
              ),
            ),
          ),
        );
      }),
    );
  }
}
