import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/get_onboarding_pages.dart';
import '../../domain/use_cases/set_onboarding_seen.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final GetOnboardingPages getOnboardingPages;
  final SetOnboardingSeen setOnboardingSeen;

  OnboardingBloc({
    required this.getOnboardingPages,
    required this.setOnboardingSeen,
  }) : super(OnboardingInitial()) {
    on<OnboardingStartedEvent>(_onStarted);
    on<OnboardingNextPressed>(_onNextPressed);
    on<OnboardingPreviousPressed>(_onPreviousPressed);
    on<OnboardingSkipPressed>(_onSkipPressed);
    on<OnboardingStartedPressed>(_onGetStartedPressed);
  }

  Future<void> _onStarted(
    OnboardingStartedEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(OnboardingLoading());

    try {
      final pages = await getOnboardingPages();

      emit(
        OnboardingLoaded(
          pages: pages,
          currentPage: 0,
        ),
      );
    } catch (e) {
      emit(OnboardingError(e.toString()));
    }
  }

  void _onNextPressed(
    OnboardingNextPressed event,
    Emitter<OnboardingState> emit,
  ) {
    final currentState = state;

    if (currentState is! OnboardingLoaded) return;

    if (currentState.currentPage < currentState.pages.length - 1) {
      emit(
        currentState.copyWith(
          currentPage: currentState.currentPage + 1,
        ),
      );
    }
  }

  void _onPreviousPressed(
    OnboardingPreviousPressed event,
    Emitter<OnboardingState> emit,
  ) {
    final currentState = state;

    if (currentState is! OnboardingLoaded) return;

    if (currentState.currentPage > 0) {
      emit(
        currentState.copyWith(
          currentPage: currentState.currentPage - 1,
        ),
      );
    }
  }

  Future<void> _onSkipPressed(
    OnboardingSkipPressed event,
    Emitter<OnboardingState> emit,
  ) async {
    await setOnboardingSeen();
    emit(OnboardingCompleted());
  }

  Future<void> _onGetStartedPressed(
    OnboardingStartedPressed event,
    Emitter<OnboardingState> emit,
  ) async {
    await setOnboardingSeen();
    emit(OnboardingCompleted());
  }
}