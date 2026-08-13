import 'package:flutter/material.dart';

/// Centralized route names and router configuration for Madinaty app.
abstract class AppRoutes {
  // Prevent instantiation
  const AppRoutes._();

  // --- Route Name Constants ---
  static const String initial = '/';
  static const String home = '/home';
  static const String splash = '/splash';
  static const String auth = '/auth';
  static const String cafeDetails = '/cafe_details';
  static const String booking = '/booking';
  static const String orders = '/orders';
  static const String notifications = '/notifications';
  static const String profile = '/profile';

  /// Pre-configured route map for [MaterialApp.routes].
  static Map<String, WidgetBuilder> get routes => {
    // Initial route maps to existing app entry point if needed
  };

  /// Generates dynamic routes for navigation.
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
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
