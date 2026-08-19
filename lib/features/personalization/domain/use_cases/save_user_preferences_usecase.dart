import '../entities/personalization_entity.dart';
import '../repositories/personalization_repository_interface.dart';

class SaveUserPreferencesUseCase {
  final PersonalizationRepositoryInterface repository;

  const SaveUserPreferencesUseCase(this.repository);

  Future<void> call(PersonalizationEntity preferences) {
    return repository.saveUserPreferences(preferences);
  }
}
