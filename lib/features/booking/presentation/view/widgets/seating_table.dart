import 'package:flutter/material.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';

class SeatingTable extends StatelessWidget {
  final String id;
  final bool selected;
  final bool booked;
  final bool rectangle;
  final double size;
  final VoidCallback onTap;

  const SeatingTable({
    super.key,
    required this.id,
    required this.selected,
    required this.booked,
    required this.onTap,
    this.rectangle = false,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor = booked
        ? AppColors.border
        : selected
        ? AppColors.primaryDark
        : AppColors.border;

    final Color backgroundColor = booked
        ? AppColors.surfaceVariant
        : selected
        ? AppColors.primaryDark
        : AppColors.surface;

    return GestureDetector(
      onTap: booked ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: rectangle ? size * 1.35 : size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: rectangle ? BoxShape.rectangle : BoxShape.circle,
          borderRadius: rectangle ? BorderRadius.circular(10) : null,
          border: Border.all(color: borderColor, width: selected ? 2 : 1),
          boxShadow: [
            if (!booked)
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 5,
              ),
          ],
        ),
        child: Center(
          child: Text(
            id,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: booked
                  ? AppColors.textMuted
                  : selected
                  ? AppColors.textWhite
                  : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}