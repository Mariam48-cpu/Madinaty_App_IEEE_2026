// domain/usecases/get_nearby_cafes.dart
import 'package:injectable/injectable.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/repositories/cafe_repository_interface.dart';

@injectable
class GetNearbyCafes {
  final CafeRepositoryInterface repository;

  GetNearbyCafes(this.repository);

  Future<List<CafeEntity>> call({
    required double latitude,
    required double longitude,
  }) {
    return repository.getNearbyCafes(latitude: latitude, longitude: longitude);
  }
}
