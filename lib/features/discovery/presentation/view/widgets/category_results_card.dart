import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:latlong2/latlong.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
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

  String getDescription(BuildContext context) {
    if (category == AppLocale.study.getString(context) ||
        category == 'هادئ للمذاكرة') {
      return AppLocale.studyDescription.getString(context);
    } else if (category == AppLocale.openNow.getString(context) ||
        category == 'مفتوح الآن') {
      return AppLocale.openNowDescription.getString(context);
    } else if (category == AppLocale.specialtyCoffee.getString(context) ||
        category == 'قهوة مختصة') {
      return AppLocale.specialtyCoffeeDescription.getString(context);
    } else {
      return AppLocale.defaultCafeDescription.getString(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
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
                  cafe.name.isNotEmpty
                      ? cafe.name
                      : AppLocale.defaultCafeName.getString(context),
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 5),
                CategoryResultLocation(cafe: cafe, userLocation: userLocation),
                const SizedBox(height: 9),
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
                            ? AppColors.surfaceVariant
                            : AppColors.border,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        cafe.isOpen
                            ? AppLocale.openNow.getString(context)
                            : AppLocale.closedNow.getString(context),
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: cafe.isOpen
                              ? AppColors.primary
                              : AppColors.textSecondary,
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
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.lightbulb_outline,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          getDescription(context),
                          textAlign: TextAlign.right,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 9,
                            height: 1.5,
                            color: AppColors.textSecondary,
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