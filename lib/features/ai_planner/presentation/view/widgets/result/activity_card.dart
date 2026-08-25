import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
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
                  color: Color(0xFF8B5E3C),
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
                  color: const Color(0x268B5E3C),
                ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE7DDD4)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.035),
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
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF2E241F),
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  place.name,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF8B5E3C),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

                          _buildMatchBadge(place.matchScore),
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
                                '${(place.distanceMeters / 1000).toStringAsFixed(1)} كم',
                          ),

                          InfoChip(
                            icon: Icons.schedule_rounded,
                            text: '${activity.durationMinutes} دقيقة',
                          ),

                          if (place.isOpen)
                            const InfoChip(
                              icon: Icons.circle,
                              text: 'مفتوح دلوقتي',
                            ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F3EC),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.auto_awesome_rounded,
                              size: 17,
                              color: Color(0xFF8B5E3C),
                            ),

                            const SizedBox(width: 8),

                            Expanded(
                              child: Text(
                                place.reason,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontSize: 12,
                                  height: 1.45,
                                  color: Color(0xFF2E241F),
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
                            foregroundColor: const Color(0xFF8B5E3C),
                            side: const BorderSide(color: Color(0xFF8B5E3C)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                          child: const Text(
                            'شوف المكان',
                            style: TextStyle(fontWeight: FontWeight.w700),
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
      color: const Color(0xFFF8F3EC),
      child: const Icon(
        Icons.local_cafe_rounded,
        size: 45,
        color: Color(0xFF8B5E3C),
      ),
    );
  }

  Widget _buildMatchBadge(int score) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF8B5E3C).withOpacity(.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$score% مناسب ليك',
        style: const TextStyle(
          color: Color(0xFF8B5E3C),
          fontWeight: FontWeight.w800,
          fontSize: 11,
        ),
      ),
    );
  }
}
