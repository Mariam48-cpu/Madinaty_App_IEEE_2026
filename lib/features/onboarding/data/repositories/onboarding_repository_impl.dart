import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import '../../domain/entities/onboarding_entity.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../data_sources/onboarding_local_data_source.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  const OnboardingRepositoryImpl(this.localDataSource);

  @override
  Future<List<OnboardingEntity>> getOnboardingPages() async {
    return const [
      OnboardingEntity(
        title: AppLocale.onboardingTitle1,
        description: AppLocale.onboardingDesc1,
        image: 'assets/images/onboarding/onboarding1.png',
      ),
      OnboardingEntity(
        title: AppLocale.onboardingTitle2,
        description: AppLocale.onboardingDesc2,
        image: 'assets/images/onboarding/onboarding2.png',
      ),
      OnboardingEntity(
        title: AppLocale.onboardingTitle3,
        description: AppLocale.onboardingDesc3,
        image: 'assets/images/onboarding/onboarding3.png',
      ),
    ];
  }

  @override
  Future<void> setOnboardingSeen() {
    return localDataSource.setOnboardingSeen();
  }

  @override
  Future<bool> isOnboardingSeen() {
    return localDataSource.isOnboardingSeen();
  }
}