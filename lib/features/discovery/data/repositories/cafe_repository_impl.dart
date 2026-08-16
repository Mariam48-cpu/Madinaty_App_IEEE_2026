import 'package:injectable/injectable.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/cafe_experience_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/menu_category_entity.dart';

import 'package:madinaty_app_ieee_2026/features/discovery/data/data_sources/google_places_datasource.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/repositories/cafe_repository_interface.dart';

import 'package:madinaty_app_ieee_2026/features/cafe/data/data_sources/cafe_firestore_data_source.dart';

@Injectable(as: CafeRepositoryInterface)
class CafeRepositoryImpl implements CafeRepositoryInterface {
  final GooglePlacesDataSource googlePlacesDataSource;
  final CafeFirestoreDataSource firebaseDataSource;

  CafeRepositoryImpl({
    required this.googlePlacesDataSource,
    required this.firebaseDataSource,
  });

  @override
  Future<List<CafeEntity>> getNearbyCafes({
    required double latitude,
    required double longitude,
  }) async {
    final cafeDtos = await googlePlacesDataSource.getNearbyCafes(
      latitude: latitude,
      longitude: longitude,
    );

    return cafeDtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<CafeEntity>> searchCafes({required String query}) async {
    final cafeDtos = await googlePlacesDataSource.searchCafes(query: query);

    return cafeDtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<CafeEntity>> getCafesByCategory({
    required String category,
  }) async {
    final cafeDtos = await googlePlacesDataSource.getCafesByCategory(
      category: category,
    );

    return cafeDtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<String>> getRandomCafePhotos() async {
    return await firebaseDataSource.getRandomCafePhotos();
  }

  @override
  Future<CafeExperienceEntity> getCafeExperience(CafeEntity cafe) async {
    throw UnimplementedError(
      'getCafeExperience is handled by CafeRepositoryFirebase',
    );
  }

  @override
  Future<List<MenuCategoryEntity>> getCafeMenu(String firebaseCafeId) async {
    return await firebaseDataSource.getCafeMenu(firebaseCafeId);
  }
}
