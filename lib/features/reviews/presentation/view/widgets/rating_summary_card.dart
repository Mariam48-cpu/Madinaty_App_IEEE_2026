import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';

class RatingSummaryCard extends StatelessWidget {
  final double averageRating;
  final int totalReviews;
  final bool hasUserReviewed;
  final VoidCallback onWriteReviewPressed;

  const RatingSummaryCard({
    super.key,
    required this.averageRating,
    required this.totalReviews,
    this.hasUserReviewed = false,
    required this.onWriteReviewPressed,
  });

  @override
  Widget build(BuildContext context) {
    final ratingDisplay =
        totalReviews > 0 ? averageRating.toStringAsFixed(1) : '0.0';

    return Column(
      children: [
        // --- Big Rating Score ---
        Text(
          ratingDisplay,
          style: const TextStyle(
            fontSize: 44,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D2521),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),

        // --- Star Icons ---
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starIndex = index + 1;
            IconData iconData;
            if (averageRating >= starIndex) {
              iconData = Icons.star_rounded;
            } else if (averageRating >= starIndex - 0.5) {
              iconData = Icons.star_half_rounded;
            } else {
              iconData = Icons.star_outline_rounded;
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Icon(
                iconData,
                size: 20,
                color: const Color(0xFF8A5A36),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),

        // --- Subtitle: Based on X reviews ---
        Text(
          '${AppLocale.basedOn.getString(context)} $totalReviews ${AppLocale.ratingsCountSuffix.getString(context)}',
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF8C827A),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),

        // --- Write / Edit Review Button ---
        SizedBox(
          height: 42,
          child: ElevatedButton(
            onPressed: onWriteReviewPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E1E1E),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 28),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            child: Text(
              hasUserReviewed
                  ? AppLocale.editReview.getString(context)
                  : AppLocale.writeYourReview.getString(context),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
