import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';

import 'package:madinaty_app_ieee_2026/core/di/injection_container.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';

import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view_model/cubit/discovery_cubit.dart';

import 'package:madinaty_app_ieee_2026/features/home/presentation/view/screens/home_screen.dart';
import 'package:madinaty_app_ieee_2026/features/home/presentation/view_model/home_cubit.dart';

class MainNavigationScreen extends StatefulWidget {
  /// 0 = Home
  /// 1 = Explore
  /// 2 = Cart
  /// 3 = Favorites
  /// 4 = Profile
  final int initialIndex;

  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  HomeCubit? _homeCubit;
  DiscoveryCubit? _discoveryCubit;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    // ============================================================
    // HOME CUBIT
    // ============================================================

    _homeCubit = sl<HomeCubit>(param1: user.uid);

    // ============================================================
    // DISCOVERY CUBIT
    // ============================================================

    _discoveryCubit = sl<DiscoveryCubit>();

    // ============================================================
    // FETCH HOME DATA
    // ============================================================

    _homeCubit!.fetchHomeData();

    // ============================================================
    // LOAD CURRENT LOCATION
    // ============================================================
    //
    // مهم جدًا:
    // كان الـ DiscoveryCubit موجود لكن loadNearbyCafes()
    // مش بتتنده خالص من هنا.
    //
    // بالتالي currentLocation كانت null طول الوقت.
    //
    // بنشغلها بعد أول frame عشان الـ Cubit يكون جاهز
    // والـ context/provider يكون موجود.
    // ============================================================

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _discoveryCubit == null) {
        return;
      }

      _loadCurrentLocation();
    });
  }

  Future<void> _loadCurrentLocation() async {
    final cubit = _discoveryCubit;

    if (cubit == null || cubit.isClosed) {
      return;
    }

    if (cubit.currentLocation != null) {
      return;
    }

    try {
      await cubit.requestLocationPermission();

      if (!cubit.isClosed) {
        await cubit.loadNearbyCafes();
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _homeCubit?.close();
    _discoveryCubit?.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // ============================================================
    // USER NOT LOGGED IN
    // ============================================================

    if (user == null || _homeCubit == null || _discoveryCubit == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              AppLocale.userNotLoggedInError.getString(context),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    // ============================================================
    // PROVIDERS
    // ============================================================

    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>.value(value: _homeCubit!),

        BlocProvider<DiscoveryCubit>.value(value: _discoveryCubit!),
      ],

      child: HomeScreen(initialIndex: widget.initialIndex),
    );
  }
}
