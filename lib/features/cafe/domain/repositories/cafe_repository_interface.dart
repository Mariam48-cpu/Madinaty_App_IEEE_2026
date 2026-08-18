import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/cafe_experience_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/menu_category_entity.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

abstract class CafeeRepositoryInterface {
  Future<CafeExperienceEntity> getCafeExperience(CafeEntity googleCafe);
  Future<List<MenuCategoryEntity>> getCafeMenu(String firebaseCafeId);
}
