import 'package:flutter/material.dart';
import 'package:madinaty_app_ieee_2026/features/ai_planner/presentation/view/screens/ai_planner_page.dart';
import '../../features/auth/presentation/view/screens/auth_screen.dart';
import '../../features/personalization/presentation/view/screens/personalization_screen.dart';
abstract class AppRoutes {
  const AppRoutes._();

  // --- Route Name Constants ---
  static const String initial = '/';
  static const String home = '/home';
  static const String splash = '/splash';
  static const String auth = '/auth';
  static const String personalization = '/personalization';
  static const String cafeDetails = '/cafe_details';
  static const String booking = '/booking';
  static const String orders = '/orders';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String aiPlanner = '/ai-planner';

  /// Pre-configured route map for [MaterialApp.routes].
  static Map<String, WidgetBuilder> get routes => {
        auth: (_) => const AuthScreen(),
        personalization: (_) => const PersonalizationScreen(),
        home: (_) => const Scaffold(body: Center(child: Text('Home'))),
        aiPlanner: (_) => const AIPlannerPage(),
      };

  /// Generates dynamic routes for navigation.
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
      case auth:
        return MaterialPageRoute(
          builder: (_) => const AuthScreen(),
          settings: settings,
        );
      case personalization:
        return MaterialPageRoute(
          builder: (_) => const PersonalizationScreen(),
          settings: settings,
        );
      case aiPlanner:
        return MaterialPageRoute(
          builder: (_) => const AIPlannerPage(),
          settings: settings,
        );
      case home:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(body: Center(child: Text('Home'))),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
          settings: settings,
        );
    }
  }
}
