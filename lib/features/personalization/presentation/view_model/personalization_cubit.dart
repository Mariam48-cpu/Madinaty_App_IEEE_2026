import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madinaty_app_ieee_2026/features/personalization/domain/use_cases/get_user_preferences_usecase.dart';
import 'package:madinaty_app_ieee_2026/features/personalization/domain/use_cases/save_user_preferences_usecase.dart';

import '../../../../core/localization/app_locale.dart';
import '../../domain/entities/personalization_entity.dart';
import 'personalization_state.dart';

class PersonalizationCubit extends Cubit<PersonalizationState> {
  final GetUserPreferencesUseCase _getUserPreferencesUseCase;
  final SaveUserPreferencesUseCase _saveUserPreferencesUseCase;

  final String currentUserId;

  /// 0 = What do you like?
  /// 1 = Why are you going out?
  final int initialStep;

  PersonalizationCubit({
    required GetUserPreferencesUseCase getUserPreferencesUseCase,
    required SaveUserPreferencesUseCase saveUserPreferencesUseCase,
    required this.currentUserId,
    this.initialStep = 0,
  }) : _getUserPreferencesUseCase = getUserPreferencesUseCase,
       _saveUserPreferencesUseCase = saveUserPreferencesUseCase,
       super(const PersonalizationInitialState());

  // ============================================================
  // LOAD PREFERENCES
  // ============================================================

  Future<void> loadPreferences({DateTime? currentDate}) async {
    if (isClosed) return;

    emit(const PersonalizationLoadingState());

    try {
      final preferences = await _getUserPreferencesUseCase(currentUserId);

      if (isClosed) return;

      final now = currentDate ?? DateTime.now();

      bool isSameDay(DateTime? d1, DateTime d2) {
        if (d1 == null) return false;
        return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
      }

      final isSelectionFromToday = preferences != null &&
          isSameDay(preferences.outingReasonDate, now);

      // ----------------------------------------------------------
      // USER ALREADY HAS SAVED INTERESTS
      // ----------------------------------------------------------

      if (preferences != null && preferences.interests.isNotEmpty) {
        if (initialStep == 0) {
          emit(
            PersonalizationLoadedState(
              selectedInterests: preferences.interests,
              selectedMood: isSelectionFromToday ? preferences.selectedMood : null,
              selectedOccasion: isSelectionFromToday ? preferences.selectedOccasion : null,
              currentStep: 0,
            ),
          );
        } else {
          emit(
            PersonalizationLoadedState(
              selectedInterests: preferences.interests,
              selectedMood: isSelectionFromToday ? preferences.selectedMood : null,
              selectedOccasion: isSelectionFromToday ? preferences.selectedOccasion : null,
              currentStep: 1,
            ),
          );
        }

        return;
      }

      // ----------------------------------------------------------
      // USER HAS NO SAVED PREFERENCES
      // ----------------------------------------------------------

      emit(
        PersonalizationLoadedState(
          selectedInterests: preferences?.interests ?? const [],
          selectedMood: null,
          selectedOccasion: null,
          currentStep: initialStep,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        PersonalizationErrorState(e.toString().replaceAll('Exception: ', '')),
      );
    }
  }

  // ============================================================
  // INTERESTS
  // ============================================================

  void toggleInterest(String interest) {
    if (isClosed) return;

    if (state is! PersonalizationLoadedState) return;

    final currentState = state as PersonalizationLoadedState;

    final interests = List<String>.from(currentState.selectedInterests);

    if (interests.contains(interest)) {
      interests.remove(interest);
    } else {
      interests.add(interest);
    }

    emit(
      currentState.copyWith(
        selectedInterests: interests,
        clearErrorMessage: true,
      ),
    );
  }

  // ============================================================
  // MOOD
  // ============================================================

  void selectMood(String mood) {
    if (isClosed) return;

    if (state is! PersonalizationLoadedState) return;

    final currentState = state as PersonalizationLoadedState;

    final isAlreadySelected = currentState.selectedMood == mood;

    emit(
      currentState.copyWith(
        selectedMood: isAlreadySelected ? null : mood,
        clearMood: isAlreadySelected,
        clearOccasion: true,
        clearErrorMessage: true,
      ),
    );
  }

  // ============================================================
  // OCCASION
  // ============================================================

  void selectOccasion(String occasion) {
    if (isClosed) return;

    if (state is! PersonalizationLoadedState) return;

    final currentState = state as PersonalizationLoadedState;

    final isAlreadySelected = currentState.selectedOccasion == occasion;

    emit(
      currentState.copyWith(
        selectedOccasion: isAlreadySelected ? null : occasion,
        clearOccasion: isAlreadySelected,
        clearMood: true,
        clearErrorMessage: true,
      ),
    );
  }

  // ============================================================
  // SELECT OPTION
  // ============================================================

  void selectOption(String optionId) {
    if (isClosed) return;

    if (state is! PersonalizationLoadedState) return;

    final currentState = state as PersonalizationLoadedState;

    const occasions = <String>{'birthday', 'date', 'friends_outing'};

    if (occasions.contains(optionId)) {
      final isSelected = currentState.selectedOccasion == optionId;

      emit(
        currentState.copyWith(
          selectedOccasion: isSelected ? null : optionId,
          clearOccasion: isSelected,
          clearMood: true,
          clearErrorMessage: true,
        ),
      );
    } else {
      final isSelected = currentState.selectedMood == optionId;

      emit(
        currentState.copyWith(
          selectedMood: isSelected ? null : optionId,
          clearMood: isSelected,
          clearOccasion: true,
          clearErrorMessage: true,
        ),
      );
    }
  }

  // ============================================================
  // GO TO STEP 2
  // ============================================================

  Future<void> goToNextStep() async {
    if (isClosed) return;

    if (state is! PersonalizationLoadedState) return;

    final currentState = state as PersonalizationLoadedState;

    // User must select at least one interest.
    if (currentState.selectedInterests.isEmpty) {
      emit(
        currentState.copyWith(errorMessage: AppLocale.selectAtLeastOneInterest),
      );

      return;
    }

    try {
      final entity = PersonalizationEntity(
        userId: currentUserId,
        interests: currentState.selectedInterests,
        selectedMood: currentState.selectedMood,
        selectedOccasion: currentState.selectedOccasion,
        updatedAt: DateTime.now(),
      );

      await _saveUserPreferencesUseCase(entity);

      if (isClosed) return;
    } catch (e) {
      if (isClosed) return;

      emit(
        currentState.copyWith(
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );

      return;
    }

    if (isClosed) return;

    emit(currentState.copyWith(currentStep: 1, errorMessage: null));
  }

  // ============================================================
  // GO BACK TO STEP 1
  // ============================================================

  void goToPreviousStep() {
    if (isClosed) return;

    if (state is! PersonalizationLoadedState) return;

    final currentState = state as PersonalizationLoadedState;

    emit(currentState.copyWith(currentStep: 0, clearErrorMessage: true));
  }

  // ============================================================
  // SAVE FINAL PREFERENCES
  // ============================================================

  Future<void> savePreferences() async {
    if (isClosed) return;

    if (state is! PersonalizationLoadedState) return;

    final currentState = state as PersonalizationLoadedState;

    // ----------------------------------------------------------
    // INTEREST VALIDATION
    // ----------------------------------------------------------

    if (currentState.selectedInterests.isEmpty) {
      emit(
        currentState.copyWith(
          errorMessage: AppLocale.selectFavoriteInterests,
          currentStep: 0,
        ),
      );

      return;
    }

    // ----------------------------------------------------------
    // MOOD / OCCASION VALIDATION
    // ----------------------------------------------------------

    final hasMood =
        currentState.selectedMood != null &&
        currentState.selectedMood!.isNotEmpty;

    final hasOccasion =
        currentState.selectedOccasion != null &&
        currentState.selectedOccasion!.isNotEmpty;

    if (!hasMood && !hasOccasion) {
      emit(currentState.copyWith(errorMessage: AppLocale.selectGoingOutReason));

      return;
    }

    // ----------------------------------------------------------
    // START SAVING
    // ----------------------------------------------------------

    emit(currentState.copyWith(isSaving: true, clearErrorMessage: true));

    try {
      final now = DateTime.now();
      final entity = PersonalizationEntity(
        userId: currentUserId,
        interests: currentState.selectedInterests,
        selectedMood: currentState.selectedMood,
        selectedOccasion: currentState.selectedOccasion,
        outingReasonDate: now,
        updatedAt: now,
      );

      await _saveUserPreferencesUseCase(entity);

      if (isClosed) return;

      emit(PersonalizationSuccessState(entity));
    } catch (e) {
      if (isClosed) return;

      emit(
        currentState.copyWith(
          isSaving: false,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }
}
