import 'package:injectable/injectable.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/data/data_sources/cafe_firestore_data_source.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/cafe_experience_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/menu_category_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/repositories/cafe_repository_interface.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

@Injectable(as: CafeeRepositoryInterface)
class CafeRepositoryFirebase implements CafeeRepositoryInterface {
  final CafeFirestoreDataSource dataSource;

  CafeRepositoryFirebase({required this.dataSource});

  @override
  Future<CafeExperienceEntity> getCafeExperience(CafeEntity googleCafe) {
    return dataSource.getCafeExperience(googleCafe);
  }

  @override
  Future<List<MenuCategoryEntity>> getCafeMenu(String firebaseCafeId) {
    return dataSource.getCafeMenu(firebaseCafeId);
  }
}
