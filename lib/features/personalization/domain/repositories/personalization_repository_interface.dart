import '../entities/personalization_entity.dart';

abstract class PersonalizationRepositoryInterface {
  /// Fetches saved user preferences for the given [userId].
  Future<PersonalizationEntity?> getUserPreferences(String userId);

  /// Saves or updates user preferences for the given [preferences].
  Future<void> saveUserPreferences(PersonalizationEntity preferences);
}
