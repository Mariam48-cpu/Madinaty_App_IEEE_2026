import 'package:flutter_test/flutter_test.dart';
import 'package:madinaty_app_ieee_2026/features/personalization/domain/entities/personalization_entity.dart';
import 'package:madinaty_app_ieee_2026/features/personalization/domain/repositories/personalization_repository_interface.dart';
import 'package:madinaty_app_ieee_2026/features/personalization/domain/use_cases/get_user_preferences_usecase.dart';
import 'package:madinaty_app_ieee_2026/features/personalization/domain/use_cases/save_user_preferences_usecase.dart';
import 'package:madinaty_app_ieee_2026/features/personalization/presentation/view_model/personalization_cubit.dart';
import 'package:madinaty_app_ieee_2026/features/personalization/presentation/view_model/personalization_state.dart';

class FakePersonalizationRepository implements PersonalizationRepositoryInterface {
  PersonalizationEntity? storedPreferences;
  bool shouldThrowError = false;

  @override
  Future<PersonalizationEntity?> getUserPreferences(String userId) async {
    if (shouldThrowError) {
      throw Exception('Failed to fetch preferences');
    }
    return storedPreferences;
  }

  @override
  Future<void> saveUserPreferences(PersonalizationEntity preferences) async {
    if (shouldThrowError) {
      throw Exception('Failed to save preferences');
    }
    storedPreferences = preferences;
  }
}

void main() {
  group('Personalization Flow Tests (Permanent Interests & Daily Mood/Occasion)', () {
    late FakePersonalizationRepository fakeRepo;
    late GetUserPreferencesUseCase getUserPreferencesUseCase;
    late SaveUserPreferencesUseCase saveUserPreferencesUseCase;

    setUp(() {
      fakeRepo = FakePersonalizationRepository();
      getUserPreferencesUseCase = GetUserPreferencesUseCase(fakeRepo);
      saveUserPreferencesUseCase = SaveUserPreferencesUseCase(fakeRepo);
    });

    test('New user (no interests saved) -> loadPreferences shows Interests screen (step 0)', () async {
      final cubit = PersonalizationCubit(
        getUserPreferencesUseCase: getUserPreferencesUseCase,
        saveUserPreferencesUseCase: saveUserPreferencesUseCase,
        currentUserId: 'test_uid_123',
      );

      expect(cubit.state, isA<PersonalizationInitialState>());

      await cubit.loadPreferences();

      expect(cubit.state, isA<PersonalizationLoadedState>());
      final state = cubit.state as PersonalizationLoadedState;
      expect(state.currentStep, 0);
      expect(state.selectedInterests, isEmpty);
      expect(state.selectedMood, isNull);
      expect(state.selectedOccasion, isNull);

      await cubit.close();
    });

    test('New user can select multiple permanent interests and proceed to step 1', () async {
      final cubit = PersonalizationCubit(
        getUserPreferencesUseCase: getUserPreferencesUseCase,
        saveUserPreferencesUseCase: saveUserPreferencesUseCase,
        currentUserId: 'test_uid_123',
      );

      await cubit.loadPreferences();

      cubit.toggleInterest('specialty_coffee');
      cubit.toggleInterest('study');
      cubit.toggleInterest('quiet_chill');

      var state = cubit.state as PersonalizationLoadedState;
      expect(state.selectedInterests, ['specialty_coffee', 'study', 'quiet_chill']);

      // Toggling again removes the interest
      cubit.toggleInterest('study');
      state = cubit.state as PersonalizationLoadedState;
      expect(state.selectedInterests, ['specialty_coffee', 'quiet_chill']);

      await cubit.goToNextStep();

      state = cubit.state as PersonalizationLoadedState;
      expect(state.currentStep, 1);
      expect(fakeRepo.storedPreferences, isNotNull);
      expect(fakeRepo.storedPreferences!.interests, ['specialty_coffee', 'quiet_chill']);

      await cubit.close();
    });

    test('Same day login: retains permanent interests AND today\'s mood/occasion on step 1', () async {
      final today = DateTime.now();
      fakeRepo.storedPreferences = PersonalizationEntity(
        userId: 'test_uid_123',
        interests: const ['specialty_coffee', 'quiet_chill'],
        selectedMood: 'quick_coffee',
        updatedAt: today,
      );

      final cubit = PersonalizationCubit(
        getUserPreferencesUseCase: getUserPreferencesUseCase,
        saveUserPreferencesUseCase: saveUserPreferencesUseCase,
        currentUserId: 'test_uid_123',
      );

      await cubit.loadPreferences(currentDate: today);

      expect(cubit.state, isA<PersonalizationLoadedState>());
      final state = cubit.state as PersonalizationLoadedState;
      expect(state.currentStep, 1);
      expect(state.selectedInterests, ['specialty_coffee', 'quiet_chill']);
      expect(state.selectedMood, 'quick_coffee');
      expect(state.selectedOccasion, isNull);

      await cubit.close();
    });

    test('New day login: retains permanent interests, resets daily mood/occasion, goes directly to step 1', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      fakeRepo.storedPreferences = PersonalizationEntity(
        userId: 'test_uid_123',
        interests: const ['specialty_coffee', 'quiet_chill'],
        selectedMood: 'quick_coffee',
        updatedAt: yesterday,
      );

      final cubit = PersonalizationCubit(
        getUserPreferencesUseCase: getUserPreferencesUseCase,
        saveUserPreferencesUseCase: saveUserPreferencesUseCase,
        currentUserId: 'test_uid_123',
      );

      // Load on today (a new day)
      await cubit.loadPreferences(currentDate: DateTime.now());

      expect(cubit.state, isA<PersonalizationLoadedState>());
      final state = cubit.state as PersonalizationLoadedState;
      // Permanent interests are loaded
      expect(state.selectedInterests, ['specialty_coffee', 'quiet_chill']);
      // Daily selection is reset for the new day
      expect(state.selectedMood, isNull);
      expect(state.selectedOccasion, isNull);
      // Because interests exist, user directly sees Mood/Occasion screen (step 1)
      expect(state.currentStep, 1);

      // Verify old data in repository is intact
      expect(fakeRepo.storedPreferences, isNotNull);

      await cubit.close();
    });

    test('Daily selection on step 1 allows only ONE option (mood OR occasion)', () async {
      fakeRepo.storedPreferences = const PersonalizationEntity(
        userId: 'test_uid_123',
        interests: ['specialty_coffee'],
      );

      final cubit = PersonalizationCubit(
        getUserPreferencesUseCase: getUserPreferencesUseCase,
        saveUserPreferencesUseCase: saveUserPreferencesUseCase,
        currentUserId: 'test_uid_123',
      );

      await cubit.loadPreferences();

      // Select an occasion
      cubit.selectOption('birthday');
      var state = cubit.state as PersonalizationLoadedState;
      expect(state.selectedOccasion, 'birthday');
      expect(state.selectedMood, isNull);

      // Select a mood -> should clear occasion and set mood
      cubit.selectOption('quick_coffee');
      state = cubit.state as PersonalizationLoadedState;
      expect(state.selectedMood, 'quick_coffee');
      expect(state.selectedOccasion, isNull);

      // Tapping the selected mood again deselects it
      cubit.selectOption('quick_coffee');
      state = cubit.state as PersonalizationLoadedState;
      expect(state.selectedMood, isNull);
      expect(state.selectedOccasion, isNull);

      await cubit.close();
    });

    test('Save preferences preserves permanent interests and saves daily selection with timestamp', () async {
      final cubit = PersonalizationCubit(
        getUserPreferencesUseCase: getUserPreferencesUseCase,
        saveUserPreferencesUseCase: saveUserPreferencesUseCase,
        currentUserId: 'test_uid_123',
      );

      await cubit.loadPreferences();
      cubit.toggleInterest('specialty_coffee');
      cubit.toggleInterest('work');
      await cubit.goToNextStep();

      cubit.selectOption('date');
      await cubit.savePreferences();

      expect(cubit.state, isA<PersonalizationSuccessState>());
      final success = cubit.state as PersonalizationSuccessState;
      expect(success.preferences.interests, ['specialty_coffee', 'work']);
      expect(success.preferences.selectedOccasion, 'date');
      expect(success.preferences.updatedAt, isNotNull);

      expect(fakeRepo.storedPreferences, isNotNull);
      expect(fakeRepo.storedPreferences!.interests, ['specialty_coffee', 'work']);
      expect(fakeRepo.storedPreferences!.selectedOccasion, 'date');

      await cubit.close();
    });

    test('Error handling in loadPreferences emits PersonalizationErrorState', () async {
      fakeRepo.shouldThrowError = true;

      final cubit = PersonalizationCubit(
        getUserPreferencesUseCase: getUserPreferencesUseCase,
        saveUserPreferencesUseCase: saveUserPreferencesUseCase,
        currentUserId: 'test_uid_123',
      );

      await cubit.loadPreferences();

      expect(cubit.state, isA<PersonalizationErrorState>());
      final errorState = cubit.state as PersonalizationErrorState;
      expect(errorState.message, contains('Failed to fetch preferences'));

      await cubit.close();
    });
  });
}
