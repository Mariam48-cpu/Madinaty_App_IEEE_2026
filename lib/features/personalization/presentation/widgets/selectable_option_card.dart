import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';

class SelectableOptionCard extends StatelessWidget {
  final String title;
  final String? svgAsset;
  final IconData? iconData;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isMultiSelect;

  const SelectableOptionCard({
    super.key,
    required this.title,
    this.svgAsset,
    this.iconData,
    required this.isSelected,
    required this.onTap,
    this.isMultiSelect = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final backgroundColor =
        isSelected ? AppColors.primaryContainer : AppColors.surface;
    final borderColor = isSelected ? AppColors.primary : AppColors.border;
    final contentColor =
        isSelected ? AppColors.onPrimaryContainer : AppColors.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 1.5 : 1.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (svgAsset != null) ...[
                SvgPicture.asset(
                  svgAsset!,
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(
                    contentColor,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 10),
              ] else if (iconData != null) ...[
                Icon(
                  iconData,
                  size: 22,
                  color: contentColor,
                ),
                const SizedBox(width: 10),
              ],
              Flexible(
                child: Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: contentColor,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isMultiSelect && isSelected) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.check_circle_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
