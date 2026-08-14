import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

abstract class CafeRepositoryInterface {
  Future<List<CafeEntity>> getNearbyCafes({
    required double latitude,
    required double longitude,
  });
  Future<List<CafeEntity>> searchCafes({required String query});
  Future<List<CafeEntity>> getCafesByCategory({required String category});
}
