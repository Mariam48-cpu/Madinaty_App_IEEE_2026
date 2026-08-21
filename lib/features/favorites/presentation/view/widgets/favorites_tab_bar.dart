import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';

import '../../../domain/entities/favorite_item_entity.dart';

class FavoritesTabBar extends StatelessWidget {
  final FavoriteTargetType selectedTab;
  final ValueChanged<FavoriteTargetType> onTabSelected;

  const FavoritesTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildTabItem(
            context: context,
            title: AppLocale.places.getString(context),
            type: FavoriteTargetType.cafe,
            isSelected: selectedTab == FavoriteTargetType.cafe,
          ),
          _buildTabItem(
            context: context,
            title: AppLocale.products.getString(context),
            type: FavoriteTargetType.product,
            isSelected: selectedTab == FavoriteTargetType.product,
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required BuildContext context,
    required String title,
    required FavoriteTargetType type,
    required bool isSelected,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () => onTabSelected(type),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? const Color(0xFF2D2521) : Colors.transparent,
                width: 2.5,
              ),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? const Color(0xFF2D2521)
                  : const Color(0xFF9E9E9E),
            ),
          ),
        ),
      ),
    );
  }
}
