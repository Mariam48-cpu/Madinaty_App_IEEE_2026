import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:madinaty_app_ieee_2026/core/di/injection_container.dart';
import 'package:madinaty_app_ieee_2026/core/routes/app_routes.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';

import '../../../../auth/presentation/view/screens/auth_screen.dart';
import '../../../../auth/presentation/view/screens/owner_dashboard_screen.dart';
import '../../../../discovery/presentation/view_model/cubit/discovery_cubit.dart';
import '../../../../personalization/presentation/view/screens/personalization_screen.dart';
import '../../../domain/use_cases/is_onboarding_seen.dart';
import 'onboarding_screen.dart';

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

  bool _isNavigating = false;

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

  // ============================================================
  // NAVIGATION
  // ============================================================

  Future<void> _handleNavigation() async {
    if (_isNavigating) return;

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted || _isNavigating) return;

    final isOnboardingSeen = await GetIt.I<IsOnboardingSeen>().call();

    if (!mounted || _isNavigating) return;

    // ============================================================
    // FIRST LAUNCH
    // ============================================================

    if (!isOnboardingSeen) {
      _navigateToOnboarding();
      return;
    }

    // ============================================================
    // FIREBASE USER
    // ============================================================

    final currentUser = FirebaseAuth.instance.currentUser;

    if (!mounted || _isNavigating) return;

    // ============================================================
    // NOT LOGGED IN
    // ============================================================

    if (currentUser == null) {
      _navigateToAuth();
      return;
    }

    // ============================================================
    // GET USER DATA
    // ============================================================

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (!mounted || _isNavigating) return;

      if (userDoc.exists && userDoc.data() != null) {
        final data = userDoc.data()!;

        final role = (data['role'] as String?)?.trim().toLowerCase();

        final cafeId = data['cafeId'] as String?;

        final interests = data['interests'] as List<dynamic>?;

        // ========================================================
        // CAFE OWNER
        // ========================================================

        if (role == 'cafe_owner' || role == 'cafeowner') {
          _navigateToOwnerDashboard(cafeId ?? '');
          return;
        }

        // ========================================================
        // EXISTING CUSTOMER
        //
        // مهم:
        // لو عنده interests محفوظة، مش هنروح Home مباشرة.
        //
        // هنفتح Personalization على STEP 1:
        // "ليه خارج النهارده؟"
        // ========================================================

        if (interests != null && interests.isNotEmpty) {
          _navigateToPersonalization(initialStep: 1);
          return;
        }
      }

      // ==========================================================
      // NEW CUSTOMER
      //
      // مفيش interests محفوظة
      // نبدأ من STEP 0:
      // "إيه اللي بتحبه؟"
      // ==========================================================

      _navigateToPersonalization(initialStep: 0);
    } catch (_) {
      if (!mounted || _isNavigating) return;

      // لو حصل خطأ في قراءة Firestore
      // نرجع للـ Home بدل ما التطبيق يعلق.
      _navigateToHome();
    }
  }

  // ============================================================
  // GO TO ONBOARDING
  // ============================================================

  void _navigateToOnboarding() {
    if (_isNavigating || !mounted) return;

    _isNavigating = true;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      (route) => false,
    );
  }

  // ============================================================
  // GO TO AUTH
  // ============================================================

  void _navigateToAuth() {
    if (_isNavigating || !mounted) return;

    _isNavigating = true;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
      (route) => false,
    );
  }

  // ============================================================
  // GO TO OWNER DASHBOARD
  // ============================================================

  void _navigateToOwnerDashboard(String cafeId) {
    if (_isNavigating || !mounted) return;

    _isNavigating = true;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => OwnerDashboardScreen(cafeId: cafeId)),
      (route) => false,
    );
  }

  // ============================================================
  // GO TO PERSONALIZATION
  // ============================================================

  void _navigateToPersonalization({required int initialStep}) {
    if (_isNavigating || !mounted) return;

    final discoveryCubit = sl<DiscoveryCubit>();

    _isNavigating = true;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => BlocProvider<DiscoveryCubit>.value(
          value: discoveryCubit,
          child: PersonalizationScreen(
            initialStep: initialStep,
            userLocation: discoveryCubit.currentLocation,
          ),
        ),
      ),
      (route) => false,
    );
  }

  // ============================================================
  // GO TO HOME
  // ============================================================

  void _navigateToHome() {
    if (_isNavigating || !mounted) return;

    _isNavigating = true;

    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ============================================================
  // UI
  // ============================================================

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
                  const Text(
                    'Madinaty',
                    style: TextStyle(
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
