import 'package:injectable/injectable.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/repositories/cafe_repository_interface.dart';

@injectable
class SearchCafes {
  final CafeRepositoryInterface repository;
  SearchCafes(this.repository);

  Future<List<CafeEntity>> call({
    required String query,
    double? latitude,
    double? longitude,
  }) => repository.searchCafes(
        query: query,
        latitude: latitude,
        longitude: longitude,
      );
}
