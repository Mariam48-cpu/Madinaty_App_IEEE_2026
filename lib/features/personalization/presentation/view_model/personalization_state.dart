import '../../domain/entities/personalization_entity.dart';

abstract class PersonalizationState {
  const PersonalizationState();
}

class PersonalizationInitialState extends PersonalizationState {
  const PersonalizationInitialState();
}

class PersonalizationLoadingState extends PersonalizationState {
  const PersonalizationLoadingState();
}

class PersonalizationLoadedState extends PersonalizationState {
  final List<String> selectedInterests;
  final String? selectedMood;
  final String? selectedOccasion;
  final int currentStep;
  final bool isSaving;
  final String? errorMessage;

  const PersonalizationLoadedState({
    this.selectedInterests = const [],
    this.selectedMood,
    this.selectedOccasion,
    this.currentStep = 0,
    this.isSaving = false,
    this.errorMessage,
  });

  PersonalizationLoadedState copyWith({
    List<String>? selectedInterests,
    String? selectedMood,
    String? selectedOccasion,
    bool clearMood = false,
    bool clearOccasion = false,
    int? currentStep,
    bool? isSaving,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return PersonalizationLoadedState(
      selectedInterests: selectedInterests ?? this.selectedInterests,
      selectedMood: clearMood ? null : (selectedMood ?? this.selectedMood),
      selectedOccasion:
          clearOccasion ? null : (selectedOccasion ?? this.selectedOccasion),
      currentStep: currentStep ?? this.currentStep,
      isSaving: isSaving ?? this.isSaving,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  bool get isInterestsValid => selectedInterests.isNotEmpty;

  bool get isMoodOccasionValid =>
      (selectedMood != null && selectedMood!.isNotEmpty) ||
      (selectedOccasion != null && selectedOccasion!.isNotEmpty);
}

class PersonalizationSuccessState extends PersonalizationState {
  final PersonalizationEntity preferences;
  const PersonalizationSuccessState(this.preferences);
}

class PersonalizationErrorState extends PersonalizationState {
  final String message;
  const PersonalizationErrorState(this.message);
}
