import 'package:flutter/material.dart';

/// A reusable star rating display widget.
///
/// Displays filled, half, and empty star icons alongside an optional rating score text.
class RatingWidget extends StatelessWidget {
  const RatingWidget({
    super.key,
    required this.rating,
    this.itemCount = 5,
    this.starSize = 16.0,
    this.starColor = const Color(0xFFFFB800),
    this.showText = true,
    this.textStyle,
    this.reviewCount,
  });

  final double rating;
  final int itemCount;
  final double starSize;
  final Color starColor;
  final bool showText;
  final TextStyle? textStyle;
  final int? reviewCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    List<Widget> stars = [];
    for (int i = 1; i <= itemCount; i++) {
      IconData iconData;
      if (rating >= i) {
        iconData = Icons.star_rounded;
      } else if (rating >= i - 0.5) {
        iconData = Icons.star_half_rounded;
      } else {
        iconData = Icons.star_border_rounded;
      }

      stars.add(Icon(iconData, size: starSize, color: starColor));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...stars,
        if (showText) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style:
                textStyle ??
                theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
          ),
          if (reviewCount != null) ...[
            const SizedBox(width: 2),
            Text(
              '($reviewCount)',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
              ),
            ),
          ],
        ],
      ],
    );
  }
}
