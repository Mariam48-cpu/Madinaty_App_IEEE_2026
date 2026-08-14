// data/repositories/cafe_repository_impl.dart
import 'package:injectable/injectable.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/data/data_sources/google_places_datasource.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/repositories/cafe_repository_interface.dart';

@Injectable(as: CafeRepositoryInterface)
class CafeRepositoryImpl implements CafeRepositoryInterface {
  final GooglePlacesDataSource dataSource;

  CafeRepositoryImpl(this.dataSource);

  @override
  Future<List<CafeEntity>> getNearbyCafes({
    required double latitude,
    required double longitude,
  }) async {
    final cafeDtos = await dataSource.getNearbyCafes(
      latitude: latitude,
      longitude: longitude,
    );
    return cafeDtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<CafeEntity>> searchCafes({required String query}) async {
    final cafeDtos = await dataSource.searchCafes(query: query);
    return cafeDtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<CafeEntity>> getCafesByCategory({
    required String category,
  }) async {
    final cafeDtos = await dataSource.getCafesByCategory(category: category);
    return cafeDtos.map((dto) => dto.toEntity()).toList();
  }
}
