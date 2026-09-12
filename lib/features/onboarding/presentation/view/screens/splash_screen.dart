import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get_it/get_it.dart';

import 'package:madinaty_app_ieee_2026/core/di/injection_container.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';

import '../../../../discovery/presentation/view_model/cubit/discovery_cubit.dart';
import '../../../../personalization/presentation/view/screens/personalization_screen.dart';
import '../../../domain/use_cases/is_onboarding_seen.dart';
import 'onboarding_screen.dart';

import '../../../../auth/presentation/view/screens/auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _logoAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _textAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 1.0, curve: Curves.easeIn),
    );

    _controller.forward();

    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    print('========== SPLASH START ==========');

    await Future.delayed(const Duration(seconds: 2));

    print('1 - Delay finished');

    if (!mounted) return;

    print('2 - Getting onboarding status');

    final isOnboardingSeen = await GetIt.I<IsOnboardingSeen>().call();

    print('3 - Onboarding seen: $isOnboardingSeen');

    if (!mounted) return;

    if (!isOnboardingSeen) {
      print('4 - Going to Onboarding');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );

      return;
    }

    print('5 - Checking Firebase user');

    final currentUser = FirebaseAuth.instance.currentUser;

    print('6 - Current user: $currentUser');

    if (!mounted) return;

    if (currentUser != null) {
      print('7 - User logged in');
      print('8 - Getting DiscoveryCubit');

      final discoveryCubit = sl<DiscoveryCubit>();

      print('9 - DiscoveryCubit created');
      print('10 - Current location: ${discoveryCubit.currentLocation}');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider<DiscoveryCubit>.value(
            value: discoveryCubit,
            child: PersonalizationScreen(
              userLocation: discoveryCubit.currentLocation,
            ),
          ),
        ),
      );

      print('11 - Navigation to Personalization done');
    } else {
      print('7 - User NOT logged in');
      print('8 - Going to Auth');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _logoAnimation,
              child: FadeTransition(
                opacity: _logoAnimation,
                child: Image.asset(
                  'assets/images/splash/cup.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 28),

            FadeTransition(
              opacity: _textAnimation,
              child: Column(
                children: [
                  Text(
                    AppLocale.appTitle.getString(context),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'MADINATY',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
