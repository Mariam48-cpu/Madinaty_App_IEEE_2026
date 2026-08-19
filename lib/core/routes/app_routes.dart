import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madinaty_app_ieee_2026/core/di/injection_container.dart';
import '../../features/home/presentation/view/screens/home_screen.dart';
import 'package:madinaty_app_ieee_2026/features/home/presentation/view_model/home_cubit.dart';

abstract class AppRoutes {
  const AppRoutes._();

  static const String initial = '/';
  static const String home = '/home';
  static const String splash = '/splash';
  static const String auth = '/auth';
  static const String cafeDetails = '/cafe_details';
  static const String booking = '/booking';
  static const String orders = '/orders';
  static const String notifications = '/notifications';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> get routes => {};

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
      case home:
        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(
                child: Text('User is not logged in'),
              ),
            ),
            settings: settings,
          );
        }

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<HomeCubit>(
              param1: user.uid,
            )..fetchHomeData(),
            child: const HomeScreen(),
          ),
          settings: settings,
        );


      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text(
                'No route defined for ${settings.name}',
              ),
            ),
          ),
          settings: settings,
        );
    }
  }
}