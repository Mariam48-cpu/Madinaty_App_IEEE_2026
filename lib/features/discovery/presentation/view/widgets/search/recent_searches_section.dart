import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/widgets/search/recent_search_item.dart';

class RecentSearchesSection extends StatelessWidget {
  final List<String> searches;
  final ValueChanged<String> onSearchSelected;
  final ValueChanged<String> onSearchRemoved;
  final VoidCallback onClearAll;

  const RecentSearchesSection({
    super.key,
    required this.searches,
    required this.onSearchSelected,
    required this.onSearchRemoved,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    if (searches.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocale.recentSearches.getString(context),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: onClearAll,
              child: Text(
                AppLocale.clear.getString(context),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.start,
          spacing: 8,
          runSpacing: 8,
          children: searches.map((search) {
            return RecentSearchItem(
              search: search,
              onSelected: () => onSearchSelected(search),
              onRemoved: () => onSearchRemoved(search),
            );
          }).toList(),
        ),
      ],
    );
  }
}