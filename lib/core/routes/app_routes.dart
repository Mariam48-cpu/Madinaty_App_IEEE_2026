import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madinaty_app_ieee_2026/core/di/injection_container.dart';
import 'package:madinaty_app_ieee_2026/features/booking/domain/entities/booking_entity.dart';
import 'package:madinaty_app_ieee_2026/features/booking/presentation/view/screens/digital_pass_screen.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view_model/cubit/discovery_cubit.dart';
import 'package:madinaty_app_ieee_2026/features/notifications/presentation/view/screens/notifications_screen.dart';
import 'package:madinaty_app_ieee_2026/features/notifications/presentation/view_model/notification_cubit.dart';

import '../../features/auth/presentation/view/screens/auth_screen.dart';
import '../../features/cart/presentation/view/screens/cart_screen.dart';
import '../../features/checkout/presentation/view/screens/checkout_screen.dart';
import '../../features/discovery/presentation/view/screens/main_navigation_screen.dart';
import '../../features/personalization/presentation/view/screens/personalization_screen.dart';
import '../../features/pre_order/presentation/view/screens/pre_order_screen.dart';

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
  static const String cart = '/cart';
  static const String preOrder = '/pre_order';

  static Map<String, WidgetBuilder> get routes => {
    auth: (_) => const AuthScreen(),
    personalization: (_) => const PersonalizationScreen(),
    home: (_) => const MainNavigationScreen(),
    cart: (_) => const CartScreen(),
    preOrder: (_) => const PreOrderScreen(),
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
          builder: (context) => PersonalizationScreen(userLocation: context.read<DiscoveryCubit>().currentLocation,),
          settings: settings,
        );

      case home:
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('User is not logged in')),
            ),
            settings: settings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => const MainNavigationScreen(),
          settings: settings,
        );

      case cart:
        final cafeNameArg = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => CartScreen(cafeName: cafeNameArg),
          settings: settings,
        );

      case preOrder:
        final args = settings.arguments;
        if (args is BookingEntity) {
          return MaterialPageRoute(
            builder: (_) => PreOrderScreen(booking: args, cafeId: args.cafeId),
            settings: settings,
          );
        } else if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => PreOrderScreen(
              booking: args['booking'] as BookingEntity?,
              cafeId: args['cafeId'] as String? ?? 'cafe_default',
              cafeName: args['cafeName'] as String?,
              cafe: args['cafe'] as CafeEntity?,
            ),
            settings: settings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => const PreOrderScreen(),
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

      case notifications:
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('User is not logged in')),
            ),
            settings: settings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
            sl<NotificationCubit>()..fetchNotifications(user.uid),
            child: NotificationsScreen(uid: user.uid),
          ),
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