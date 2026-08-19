import '../repositories/onboarding_repository.dart';

class SetOnboardingSeen {
  final OnboardingRepository repository;

  SetOnboardingSeen(this.repository);

  Future<void> call() async {
    return await repository.setOnboardingSeen();
  }
}