import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../features/auth/presentation/view/screens/auth_screen.dart';
import '../../features/booking/domain/entities/booking_entity.dart';
import '../../features/cart/domain/entities/cart_item_entity.dart';
import '../../features/checkout/presentation/view/screens/checkout_screen.dart';

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
  static const String checkout = '/checkout';

  /// Pre-configured route map for [MaterialApp.routes].
  static Map<String, WidgetBuilder> get routes => {
    // Initial route maps to existing app entry point if needed
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
      case home:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(body: Center(child: Text('Home'))),
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
  userId: 'user_123',
  cafeId: 'cafe_tbs',
  cafeName: 'The Bakery Shop (TBS)',
  cafeAddress: 'أوبن إير مول، مدينتي',
  cafeImageUrl: 'https://images.unsplash.com/photo-1554118811-1e0d58224f24',
  bookingDateTime: DateTime.now().add(const Duration(days: 2, hours: 4)),
  guestsCount: 4,
  seatingPreference: 'صالة داخلية',
  occasion: 'جلسة عمل',
  tableReservationFee: 50.0,
  preOrderItems: const [
    CartItemEntity(
      id: '1',
      title: 'Spanish Latte',
      price: 70.0,
      quantity: 2,
      imageUrl: 'https://images.unsplash.com/photo-1541167760496-1628856ab772',
    ),
  ],
);
