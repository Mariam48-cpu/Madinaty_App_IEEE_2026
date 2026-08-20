import '../entities/onboarding_entity.dart';

abstract class OnboardingRepository {
  Future<List<OnboardingEntity>> getOnboardingPages();
  Future<void> setOnboardingSeen();
  Future<bool> isOnboardingSeen();
}