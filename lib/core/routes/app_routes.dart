import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../features/auth/presentation/view/screens/auth_screen.dart';
import '../../features/booking/domain/entities/booking_entity.dart';
import '../../features/booking/presentation/view/screens/digital_pass_screen.dart';
import '../../features/checkout/presentation/view/screens/checkout_screen.dart';
import '../../features/discovery/presentation/view/screens/main_navigation_screen.dart';
import '../../features/personalization/presentation/view/screens/personalization_screen.dart';

abstract class AppRoutes {
  const AppRoutes._();

  static const String initial = '/';
  static const String home = '/home';
  static const String splash = '/splash';
  static const String auth = '/auth';
  static const String personalization = '/personalization';
  static const String cafeDetails = '/cafe_details';
  static const String booking = '/booking';
  static const String digitalPass = '/digital_pass';
  static const String orders = '/orders';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String checkout = '/checkout';

  // static Map<String, WidgetBuilder> get routes => {
  //   auth: (_) => const AuthScreen(),
  //   personalization: (_) => const PersonalizationScreen(),
  //   home: (_) => const MainNavigationScreen(),
  // };
  static Map<String, WidgetBuilder> get routes => {
    auth: (_) => const AuthScreen(),
    personalization: (_) => const PersonalizationScreen(),
    home: (_) => const MainNavigationScreen(),
    checkout: (_) => CheckoutScreen(booking: dummyBooking),
  };

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
          builder: (_) => const MainNavigationScreen(),
          settings: settings,
        );

      case checkout:
        final bookingArg = settings.arguments as BookingEntity?;
        return MaterialPageRoute(
          builder: (_) => CheckoutScreen(booking: bookingArg ?? dummyBooking),
          settings: settings,
        );

      case digitalPass:
        final bookingArg = settings.arguments as BookingEntity?;
        return MaterialPageRoute(
          builder: (_) => DigitalPassScreen(booking: bookingArg ?? dummyBooking),
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