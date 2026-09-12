import 'package:flutter/material.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/domain/entities/group_cafe_entity.dart';

import 'picked_by_section.dart';

class WinnerCard extends StatelessWidget {
  final GroupCafePickEntity winner;
  final List<String> pickedBy;
  final double imageHeight;
  final bool showPickedBy;

  const WinnerCard({
    super.key,
    required this.winner,
    required this.pickedBy,
    this.imageHeight = 185,
    this.showPickedBy = true,
  });

  Widget buildImagePlaceholder(BuildContext context) {
    return Container(
      width: double.infinity,
      height: imageHeight,
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(
        child: Icon(
          Icons.local_cafe_rounded,
          size: 60,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // IMAGE
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: winner.imageUrl.isNotEmpty
                ? Image.network(
                    winner.imageUrl,
                    width: double.infinity,
                    height: imageHeight,
                    fit: BoxFit.cover,
                    errorBuilder: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return buildImagePlaceholder(context);
                    },
                  )
                : buildImagePlaceholder(context),
          ),
        ),

        const SizedBox(height: 18),
        Text(
          winner.cafeName,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: imageHeight >= 220 ? 28 : 27,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 8),
        if (winner.rating > 0)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFC857)
                  .withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '⭐ ${winner.rating.toStringAsFixed(1)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        if (winner.address.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            winner.address,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.6),
            ),
          ),
        ],

        if (showPickedBy) ...[    
            const SizedBox(height: 20),
          PickedBySection(
            names: pickedBy,
            compact: true,
          ),
        ],
      ],
    );
  }
}