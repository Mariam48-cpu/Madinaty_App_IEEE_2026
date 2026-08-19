import '../entities/onboarding_entity.dart';
import '../repositories/onboarding_repository.dart';

class GetOnboardingPages {
  final OnboardingRepository repository;

  GetOnboardingPages(this.repository);

  Future<List<OnboardingEntity>> call() async {
    return await repository.getOnboardingPages();
  }
}