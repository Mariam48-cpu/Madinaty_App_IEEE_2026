import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';
import 'menu_category_entity.dart';

class CafeExperienceEntity {
  final CafeEntity cafe;
  final List<MenuCategoryEntity> menu;

  const CafeExperienceEntity({required this.cafe, required this.menu});
}
