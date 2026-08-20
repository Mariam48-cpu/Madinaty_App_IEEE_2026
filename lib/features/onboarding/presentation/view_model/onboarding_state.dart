import '../../domain/entities/onboarding_entity.dart';

abstract class OnboardingState {}

class OnboardingInitial extends OnboardingState {}

class OnboardingLoading extends OnboardingState {}

class OnboardingLoaded extends OnboardingState {
  final List<OnboardingEntity> pages;
  final int currentPage;

  OnboardingLoaded({
    required this.pages,
    this.currentPage = 0,
  });

  OnboardingLoaded copyWith({
    List<OnboardingEntity>? pages,
    int? currentPage,
  }) {
    return OnboardingLoaded(
      pages: pages ?? this.pages,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class OnboardingCompleted extends OnboardingState {}

class OnboardingError extends OnboardingState {
  final String message;

  OnboardingError(this.message);
}