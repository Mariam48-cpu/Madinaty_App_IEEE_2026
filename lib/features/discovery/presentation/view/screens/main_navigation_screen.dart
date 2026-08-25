import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/di/injection_container.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/features/home/presentation/view/screens/home_screen.dart';
import 'package:madinaty_app_ieee_2026/features/home/presentation/view_model/home_cubit.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  HomeCubit? _homeCubit;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      _homeCubit = sl<HomeCubit>(
        param1: user.uid,
      );

      // Fetch recommendations based on user preferences
      _homeCubit!.fetchHomeData();
    }
  }

  @override
  void dispose() {
    _homeCubit?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || _homeCubit == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            AppLocale.userNotLoggedInError.getString(context),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return BlocProvider.value(
      value: _homeCubit!,
      child: const HomeScreen(),
    );
  }
}