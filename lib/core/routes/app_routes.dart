import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madinaty_app_ieee_2026/core/di/injection_container.dart';
import 'package:madinaty_app_ieee_2026/features/notifications/presentation/view/screens/notifications_screen.dart';
import 'package:madinaty_app_ieee_2026/features/notifications/presentation/view_model/notification_cubit.dart';

import '../../features/auth/presentation/view/screens/auth_screen.dart';
import '../../features/booking/domain/entities/booking_entity.dart';
import '../../features/checkout/presentation/view/screens/checkout_screen.dart';
import '../../features/discovery/presentation/view/screens/main_navigation_screen.dart';
import '../../features/onboarding/presentation/view/screens/splash_screen.dart';
import '../../features/personalization/presentation/view/screens/personalization_screen.dart';

abstract class AppRoutes {
  const AppRoutes._();

  static const String initial = '/';
  static const String splash = '/splash';
  static const String home = '/home';
  static const String auth = '/auth';
  static const String personalization = '/personalization';
  static const String cafeDetails = '/cafe_details';
  static const String booking = '/booking';
  static const String orders = '/orders';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String checkout = '/checkout';

  static Map<String, WidgetBuilder> get routes => {
        splash: (_) => const SplashScreen(),
        auth: (_) => const AuthScreen(),
        personalization: (_) => const PersonalizationScreen(),
        home: (_) => const MainNavigationScreen(),
      };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // ==========================================
      // SPLASH
      // ==========================================

      case initial:
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );

      // ==========================================
      // AUTH
      // ==========================================

      case auth:
        return MaterialPageRoute(
          builder: (_) => const AuthScreen(),
          settings: settings,
        );

      // ==========================================
      // PERSONALIZATION
      // ==========================================

      case personalization:
        return MaterialPageRoute(
          builder: (_) => const PersonalizationScreen(),
          settings: settings,
        );

      // ==========================================
      // HOME
      // ==========================================

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

      // ==========================================
      // CHECKOUT
      // ==========================================

      case checkout:
        final bookingArg = settings.arguments as BookingEntity?;

        return MaterialPageRoute(
          builder: (_) => CheckoutScreen(
            booking: bookingArg ?? dummyBooking,
          ),
          settings: settings,
        );

      // ==========================================
      // NOTIFICATIONS
      // ==========================================

      case notifications:
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
            create: (_) => sl<NotificationCubit>()
              ..fetchNotifications(user.uid),
            child: NotificationsScreen(
              uid: user.uid,
            ),
          ),
          settings: settings,
        );

      // ==========================================
      // UNKNOWN ROUTE
      // ==========================================

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text(
                'No route defined for ${settings.name}',
              ),
            ),
          ),
        );
    }
  }
}

final dummyBooking = BookingEntity(
  id: 'booking_dummy_001',
  userId: 'user_123',
  cafeId: 'cafe_tbs',
  date: DateTime.now().add(
    const Duration(days: 2),
  ),
  time: '18:00',
  guests: 4,
  seatingPreference: 'صالة داخلية',
  occasion: 'جلسة عمل',
  status: BookingStatus.pending,
  createdAt: DateTime.now(),
);