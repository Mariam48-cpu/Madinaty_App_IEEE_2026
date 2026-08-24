import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:latlong2/latlong.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/features/ai_planner/domain/entities/ai_plan_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/screens/cafe_details_screen.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

import 'info_chip.dart';

class ActivityCard extends StatelessWidget {
  final AIPlanActivityEntity activity;
  final int index;
  final int totalActivities;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.index,
    required this.totalActivities,
  });

  void _openPlace(BuildContext context, AIPlanPlaceEntity place) {
    final cafe = CafeEntity(
      id: place.id,
      name: place.name,
      location: LatLng(place.location.latitude, place.location.longitude),
      rating: place.rating,
      reviewsCount: place.reviewsCount,
      photos: List<String>.from(place.photos),
      address: place.address,
      isOpen: place.isOpen,
      description: '',
      openingHours: place.openingHours,
      attributes: List<String>.from(place.attributes),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CafeDetailsScreen(cafe: cafe)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final place = activity.place;

    if (place == null) {
      return const SizedBox.shrink();
    }

    final imageUrl = place.photos.isNotEmpty ? place.photos.first : '';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 34,
          child: Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              if (index < totalActivities - 1)
                Container(
                  width: 2,
                  height: 155,
                  color: AppColors.primary.withValues(alpha: 0.15),
                ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE7DDD4)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.035),
                  blurRadius: 16,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageUrl.isNotEmpty)
                  Image.network(
                    imageUrl,
                    height: 145,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildImageFallback();
                    },
                  )
                else
                  _buildImageFallback(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activity.title,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  place.name,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildMatchBadge(context, place.matchScore),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 7,
                        runSpacing: 7,
                        children: [
                          InfoChip(
                            icon: Icons.star_rounded,
                            text: place.rating.toStringAsFixed(1),
                          ),
                          InfoChip(
                            icon: Icons.location_on_outlined,
                            text:
                            '${(place.distanceMeters / 1000).toStringAsFixed(1)} ${AppLocale.distanceKm.getString(context)}',
                          ),
                          InfoChip(
                            icon: Icons.schedule_rounded,
                            text:
                            '${activity.durationMinutes} ${AppLocale.minutes.getString(context)}',
                          ),
                          if (place.isOpen)
                            InfoChip(
                              icon: Icons.circle,
                              text: AppLocale.openNow.getString(context),
                            ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.auto_awesome_rounded,
                              size: 17,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                place.reason,
                                style: const TextStyle(
                                  fontSize: 12,
                                  height: 1.45,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: OutlinedButton(
                          onPressed: () {
                            _openPlace(context, place);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                          child: Text(
                            AppLocale.viewPlace.getString(context),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageFallback() {
    return Container(
      height: 145,
      width: double.infinity,
      color: AppColors.background,
      child: const Icon(
        Icons.local_cafe_rounded,
        size: 45,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildMatchBadge(BuildContext context, int score) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$score% ${AppLocale.matchForYou.getString(context)}',
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
          fontSize: 11,
        ),
      ),
    );
  }
}