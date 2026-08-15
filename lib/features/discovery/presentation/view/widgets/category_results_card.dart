import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/widgets/category_result_image.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/widgets/category_result_location.dart';

class CategoryResultsCard extends StatelessWidget {
  final CafeEntity cafe;
  final LatLng? userLocation;
  final String category;

  const CategoryResultsCard({
    super.key,
    required this.cafe,
    required this.userLocation,
    required this.category,
  });

  String getDescription() {
    switch (category) {
      case 'هادئ للمذاكرة':
        return 'مكان مناسب للمذاكرة والعمل في أجواء هادئة.';

      case 'مفتوح الآن':
        return 'مفتوح الآن ويمكنك زيارته في الوقت الحالي.';

      case 'قهوة مختصة':
        return 'مكان مناسب لمحبي القهوة والمشروبات المختصة.';

      default:
        return 'مكان مناسب للقهوة والجلوس وقضاء وقت ممتع.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          CategoryResultImage(cafe: cafe),

          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  cafe.name.isNotEmpty ? cafe.name : 'كافيه',
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2521),
                  ),
                ),

                SizedBox(height: 5),
                CategoryResultLocation(cafe: cafe, userLocation: userLocation),

                SizedBox(height: 9),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: cafe.isOpen
                            ? Color(0xFFFFE5C9)
                            : Color(0xFFEAEAEA),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        cafe.isOpen ? 'مفتوح الآن' : 'مغلق الآن',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: cafe.isOpen
                              ? Color(0xFF9A5A20)
                              : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 9),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFF8F4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 18,
                        color: Color(0xFFB47C54),
                      ),

                      SizedBox(width: 7),

                      Expanded(
                        child: Text(
                          getDescription(),
                          textAlign: TextAlign.right,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9,
                            height: 1.5,
                            color: Color(0xFF6D5B51),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
