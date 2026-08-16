import '../entities/personalization_entity.dart';
import '../repositories/personalization_repository_interface.dart';

class GetUserPreferencesUseCase {
  final PersonalizationRepositoryInterface repository;

  const GetUserPreferencesUseCase(this.repository);

  Future<PersonalizationEntity?> call(String userId) {
    return repository.getUserPreferences(userId);
  }
}
