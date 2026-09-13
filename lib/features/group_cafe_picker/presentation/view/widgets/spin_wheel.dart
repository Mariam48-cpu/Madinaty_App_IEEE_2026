import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/domain/entities/group_cafe_entity.dart';

class SpinWheel extends StatelessWidget {
  final List<GroupCafePickEntity> cafes;
  final StreamController<int> selected;

  const SpinWheel({super.key, required this.cafes, required this.selected});

  static const List<Color> wheelColors = [
    Color(0xFFB982FF),
    Color(0xFFFF9F80),
    Color(0xFF70C7C5),
    Color(0xFFFFC857),
    Color(0xFF8EA7FF),
    Color(0xFFFF8FB1),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.14),
            blurRadius: 35,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          FortuneWheel(
            selected: selected.stream,
            animateFirst: false,
            indicators: [
              FortuneIndicator(
                alignment: Alignment.topCenter,
                child: TriangleIndicator(
                  color: AppColors.primary,
                  width: 28,
                  height: 34,
                  elevation: 4,
                ),
              ),
            ],
            items: [
              for (int i = 0; i < cafes.length; i++)
                FortuneItem(
                  style: FortuneItemStyle(
                    color: wheelColors[i % wheelColors.length],
                    borderColor: Colors.white,
                    borderWidth: 3,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    child: Text(
                      cafes[i].cafeName,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: AppColors.primary, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 12,
                ),
              ],
            ),
            child: const Center(
              child: Text('☕', style: TextStyle(fontSize: 30)),
            ),
          ),
        ],
      ),
    );
  }
}
