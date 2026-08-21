import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../features/auth/presentation/view/screens/auth_screen.dart';
import '../../features/booking/domain/entities/booking_entity.dart';
import '../../features/cart/domain/entities/cart_item_entity.dart';
import '../../features/checkout/presentation/view/screens/checkout_screen.dart';
import '../../features/discovery/presentation/view/screens/main_navigation_screen.dart';
import '../../features/personalization/presentation/view/screens/personalization_screen.dart';

/// Centralized route names and router configuration for Madinaty app.
abstract class AppRoutes {
  // Prevent instantiation
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
  static const String checkout = '/checkout';

  /// Pre-configured route map for [MaterialApp.routes].
  static Map<String, WidgetBuilder> get routes => {
    auth: (_) => const AuthScreen(),
    personalization: (_) => const PersonalizationScreen(),
    home: (_) => const MainNavigationScreen(),
  };

  /// Generates dynamic routes for navigation.
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
        final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;
        return MaterialPageRoute(
          builder: (_) => isLoggedIn
              ? CheckoutScreen(booking: dummyBooking)
              : const AuthScreen(),
          settings: settings,
        );
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
      case home:
        return MaterialPageRoute(
          builder: (_) => const MainNavigationScreen(),
          settings: settings,
        );
      case checkout:
        final bookingArg = settings.arguments as BookingEntity?;
        return MaterialPageRoute(
          builder: (_) => CheckoutScreen(booking: bookingArg ?? dummyBooking),
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

final dummyBooking = BookingEntity(
  id: 'booking_dummy_001',
  userId: 'user_123',
  cafeId: 'cafe_tbs',
  date: DateTime.now().add(const Duration(days: 2)),
  time: '18:00',
  guests: 4,
  seatingPreference: 'صالة داخلية',
  occasion: 'جلسة عمل',
  status: BookingStatus.pending,
  createdAt: DateTime.now(),
);