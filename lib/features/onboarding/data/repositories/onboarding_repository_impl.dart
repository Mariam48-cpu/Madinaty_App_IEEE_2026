import '../../domain/entities/onboarding_entity.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../data_sources/onboarding_local_data_source.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl(this.localDataSource);

  @override
  Future<List<OnboardingEntity>> getOnboardingPages() async {
    return const [
      OnboardingEntity(
        title: 'اكتشف المكان المناسب ليك',
        description:
            'اكتشف أفضل الكافيهات والأماكن اللي تناسب ذوقك واهتماماتك.',
        image: 'assets/images/onboarding/onboarding1.png',
      ),
      OnboardingEntity(
        title: 'احجز تجربتك بسهولة',
        description:
            'اختار الوقت والمناسبة والموقع اللي يناسبك واحجز مكانك بسهولة.',
        image: 'assets/images/onboarding/onboarding2.png',
      ),
      OnboardingEntity(
        title: 'جهز طلبك قبل ما توصل',
        description:
            'اختار قهوتك وحلوياتك من المنيو وخلي طلبك جاهز وقت وصولك.',
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