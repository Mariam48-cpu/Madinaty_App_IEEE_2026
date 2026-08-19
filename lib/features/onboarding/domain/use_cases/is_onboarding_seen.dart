import '../repositories/onboarding_repository.dart';

class IsOnboardingSeen {
  final OnboardingRepository repository;

  IsOnboardingSeen(this.repository);

  Future<bool> call() async {
    return await repository.isOnboardingSeen();
  }
}
