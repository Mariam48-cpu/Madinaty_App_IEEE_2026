import 'package:shared_preferences/shared_preferences.dart';

class OnboardingLocalDataSource {
  final SharedPreferences preferences;

  OnboardingLocalDataSource(this.preferences);

  static const String onboardingSeenKey = 'onboardingSeen';

  Future<void> setOnboardingSeen() async {
    await preferences.setBool(onboardingSeenKey, true);
  }

  Future<bool> isOnboardingSeen() async {
    return preferences.getBool(onboardingSeenKey) ?? false;
  }
}