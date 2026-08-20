import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/features/reviews/presentation/view_model/cubit/reviews_state.dart';

class ReviewsFilterRow extends StatelessWidget {
  final ReviewFilterType selectedFilter;
  final int totalCount;
  final int withPhotosCount;
  final ValueChanged<ReviewFilterType> onFilterSelected;

  const ReviewsFilterRow({
    super.key,
    required this.selectedFilter,
    required this.totalCount,
    required this.withPhotosCount,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildFilterChip(
            context: context,
            label: '${AppLocale.all.getString(context)} ($totalCount)',
            isSelected: selectedFilter == ReviewFilterType.all,
            onTap: () => onFilterSelected(ReviewFilterType.all),
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context: context,
            label:
                '${AppLocale.withPhotos.getString(context)} ($withPhotosCount)',
            isSelected: selectedFilter == ReviewFilterType.withPhotos,
            onTap: () => onFilterSelected(ReviewFilterType.withPhotos),
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context: context,
            label: AppLocale.highestRating.getString(context),
            isSelected: selectedFilter == ReviewFilterType.highestRating,
            onTap: () => onFilterSelected(ReviewFilterType.highestRating),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2D2521) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF2D2521) : const Color(0xFFEADBCE),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF6E6761),
          ),
        ),
      ),
    );
  }
}
