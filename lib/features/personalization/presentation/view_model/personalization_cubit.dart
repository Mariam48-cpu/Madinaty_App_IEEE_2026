import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/app_locale.dart';
import '../../domain/entities/personalization_entity.dart';
import '../../domain/use_cases/get_user_preferences_usecase.dart';
import '../../domain/use_cases/save_user_preferences_usecase.dart';
import 'personalization_state.dart';

class PersonalizationCubit extends Cubit<PersonalizationState> {
  final GetUserPreferencesUseCase _getUserPreferencesUseCase;
  final SaveUserPreferencesUseCase _saveUserPreferencesUseCase;

  final String currentUserId;
  final int initialStep;

  PersonalizationCubit({
    required GetUserPreferencesUseCase getUserPreferencesUseCase,
    required SaveUserPreferencesUseCase saveUserPreferencesUseCase,
    required this.currentUserId,
    this.initialStep = 0,
  })  : _getUserPreferencesUseCase = getUserPreferencesUseCase,
        _saveUserPreferencesUseCase = saveUserPreferencesUseCase,
        super(const PersonalizationInitialState());

  // =========================================================
  // LOAD PREFERENCES
  // =========================================================

  Future<void> loadPreferences({DateTime? currentDate}) async {
    if (isClosed) return;

    emit(const PersonalizationLoadingState());

    try {
      final now = currentDate ?? DateTime.now();

      final preferences =
          await _getUserPreferencesUseCase(currentUserId);

      // Cubit may have been closed while waiting for Firestore.
      if (isClosed) return;

      if (preferences != null &&
          preferences.interests.isNotEmpty) {
        final isSameDay =
            preferences.updatedAt != null &&
            _isSameDay(
              preferences.updatedAt,
              now,
            );

        if (isSameDay) {
          emit(
            PersonalizationLoadedState(
              selectedInterests: preferences.interests,
              selectedMood: preferences.selectedMood,
              selectedOccasion: preferences.selectedOccasion,
              currentStep: 1,
            ),
          );
        } else {
          emit(
            PersonalizationLoadedState(
              selectedInterests: preferences.interests,
              selectedMood: null,
              selectedOccasion: null,
              currentStep: 1,
            ),
          );
        }
      } else {
        emit(
          PersonalizationLoadedState(
            selectedInterests:
                preferences?.interests ?? const [],
            selectedMood: null,
            selectedOccasion: null,
            currentStep: initialStep,
          ),
        );
      }
    } catch (e) {
      if (isClosed) return;

      emit(
        PersonalizationErrorState(
          e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  // =========================================================
  // DATE CHECK
  // =========================================================

  bool _isSameDay(
    DateTime? date1,
    DateTime? date2,
  ) {
    if (date1 == null || date2 == null) {
      return false;
    }

    final local1 = date1.toLocal();
    final local2 = date2.toLocal();

    return local1.year == local2.year &&
        local1.month == local2.month &&
        local1.day == local2.day;
  }

  // =========================================================
  // INTERESTS
  // =========================================================

  void toggleInterest(String interest) {
    if (isClosed) return;

    if (state is! PersonalizationLoadedState) {
      return;
    }

    final currentState =
        state as PersonalizationLoadedState;

    final updatedList =
        List<String>.from(
      currentState.selectedInterests,
    );

    if (updatedList.contains(interest)) {
      updatedList.remove(interest);
    } else {
      updatedList.add(interest);
    }

    emit(
      currentState.copyWith(
        selectedInterests: updatedList,
        clearErrorMessage: true,
      ),
    );
  }

  // =========================================================
  // MOOD
  // =========================================================

  void selectMood(String mood) {
    if (isClosed) return;

    if (state is! PersonalizationLoadedState) {
      return;
    }

    final currentState =
        state as PersonalizationLoadedState;

    final isSelected =
        currentState.selectedMood == mood;

    emit(
      currentState.copyWith(
        selectedMood:
            isSelected ? null : mood,
        clearMood: isSelected,
        clearOccasion: true,
        clearErrorMessage: true,
      ),
    );
  }

  // =========================================================
  // OCCASION
  // =========================================================

  void selectOccasion(String occasion) {
    if (isClosed) return;

    if (state is! PersonalizationLoadedState) {
      return;
    }

    final currentState =
        state as PersonalizationLoadedState;

    final isSelected =
        currentState.selectedOccasion == occasion;

    emit(
      currentState.copyWith(
        selectedOccasion:
            isSelected ? null : occasion,
        clearOccasion: isSelected,
        clearMood: true,
        clearErrorMessage: true,
      ),
    );
  }

  // =========================================================
  // SELECT OPTION
  // =========================================================

  void selectOption(String optionId) {
    if (isClosed) return;

    if (state is! PersonalizationLoadedState) {
      return;
    }

    final currentState =
        state as PersonalizationLoadedState;

    const occasions = {
      'birthday',
      'date',
      'friends_outing',
    };

    if (occasions.contains(optionId)) {
      final isSelected =
          currentState.selectedOccasion == optionId;

      emit(
        currentState.copyWith(
          selectedOccasion:
              isSelected ? null : optionId,
          clearOccasion: isSelected,
          clearMood: true,
          clearErrorMessage: true,
        ),
      );
    } else {
      final isSelected =
          currentState.selectedMood == optionId;

      emit(
        currentState.copyWith(
          selectedMood:
              isSelected ? null : optionId,
          clearMood: isSelected,
          clearOccasion: true,
          clearErrorMessage: true,
        ),
      );
    }
  }

  // =========================================================
  // NEXT STEP
  // =========================================================

  Future<void> goToNextStep() async {
    if (isClosed) return;

    if (state is! PersonalizationLoadedState) {
      return;
    }

    final currentState =
        state as PersonalizationLoadedState;

    if (currentState.selectedInterests.isEmpty) {
      emit(
        currentState.copyWith(
          errorMessage:
              AppLocale.selectAtLeastOneInterest,
        ),
      );

      return;
    }

    try {
      final entity = PersonalizationEntity(
        userId: currentUserId,
        interests:
            currentState.selectedInterests,
        selectedMood:
            currentState.selectedMood,
        selectedOccasion:
            currentState.selectedOccasion,
        updatedAt: DateTime.now(),
      );

      await _saveUserPreferencesUseCase(entity);

      if (isClosed) return;
    } catch (_) {
      // Continue even if saving fails.
      if (isClosed) return;
    }

    if (isClosed) return;

    emit(
      currentState.copyWith(
        currentStep: 1,
        errorMessage: null,
      ),
    );
  }

  // =========================================================
  // PREVIOUS STEP
  // =========================================================

  void goToPreviousStep() {
    if (isClosed) return;

    if (state is! PersonalizationLoadedState) {
      return;
    }

    final currentState =
        state as PersonalizationLoadedState;

    emit(
      currentState.copyWith(
        currentStep: 0,
        errorMessage: null,
      ),
    );
  }

  // =========================================================
  // SAVE PREFERENCES
  // =========================================================

  Future<void> savePreferences() async {
    if (isClosed) return;

    if (state is! PersonalizationLoadedState) {
      return;
    }

    final currentState =
        state as PersonalizationLoadedState;

    if (currentState.selectedInterests.isEmpty) {
      emit(
        currentState.copyWith(
          errorMessage:
              AppLocale.selectFavoriteInterests,
          currentStep: 0,
        ),
      );

      return;
    }

    final hasMood =
        currentState.selectedMood != null &&
        currentState.selectedMood!.isNotEmpty;

    final hasOccasion =
        currentState.selectedOccasion != null &&
        currentState.selectedOccasion!.isNotEmpty;

    if (!hasMood && !hasOccasion) {
      emit(
        currentState.copyWith(
          errorMessage:
              AppLocale.selectGoingOutReason,
        ),
      );

      return;
    }

    emit(
      currentState.copyWith(
        isSaving: true,
        errorMessage: null,
      ),
    );

    try {
      final entity = PersonalizationEntity(
        userId: currentUserId,
        interests:
            currentState.selectedInterests,
        selectedMood:
            currentState.selectedMood,
        selectedOccasion:
            currentState.selectedOccasion,
        updatedAt: DateTime.now(),
      );

      await _saveUserPreferencesUseCase(entity);

      if (isClosed) return;

      emit(
        PersonalizationSuccessState(entity),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        currentState.copyWith(
          isSaving: false,
          errorMessage:
              e.toString().replaceAll(
                    'Exception: ',
                    '',
                  ),
        ),
      );
    }
  }
}