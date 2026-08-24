import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/cafe_experience_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/menu_category_entity.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

abstract class CafeRepositoryInterface {
  Future<List<CafeEntity>> getNearbyCafes({
    required double latitude,
    required double longitude,
  });

  Future<List<CafeEntity>> searchCafes({
    required String query,
    double? latitude,
    double? longitude,
  });

  Future<List<CafeEntity>> getCafesByCategory({
    required String category,
    double? latitude,
    double? longitude,
  });

  Future<List<String>> getRandomCafePhotos();

  Future<CafeExperienceEntity> getCafeExperience(CafeEntity cafe);

  Future<List<MenuCategoryEntity>> getCafeMenu(String cafeId);
}
