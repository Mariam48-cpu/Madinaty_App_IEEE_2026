import 'package:injectable/injectable.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/cafe_experience_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/repositories/cafe_repository_interface.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

@injectable
class GetCafeExperienceUseCase {
  final CafeeRepositoryInterface repository;

  GetCafeExperienceUseCase({
    required this.repository,
  });

  Future<CafeExperienceEntity> call(CafeEntity cafe) {
    return repository.getCafeExperience(cafe);
  }
}