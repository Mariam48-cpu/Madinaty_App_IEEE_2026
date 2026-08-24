import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:madinaty_app_ieee_2026/core/di/injection_container.dart';
import 'package:madinaty_app_ieee_2026/features/home/presentation/view/screens/home_screen.dart';
import 'package:madinaty_app_ieee_2026/features/home/presentation/view_model/home_cubit.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends State<MainNavigationScreen> {
  late final HomeCubit _homeCubit;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      _homeCubit = sl<HomeCubit>(
        param1: user.uid,
      );

      // Fetch the recommendations based on
      // the user's latest personalization preferences.
      _homeCubit.fetchHomeData();
    }
  }

  @override
  void dispose() {
    _homeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('يجب تسجيل الدخول أولاً'),
        ),
      );
    }

    return BlocProvider.value(
      value: _homeCubit,
      child: const HomeScreen(),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_localization/flutter_localization.dart';
// import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
// import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/screens/location_permission_gate.dart';
// import 'package:madinaty_app_ieee_2026/features/favorites/presentation/view/screens/favorites_screen.dart';

// class MainNavigationScreen extends StatefulWidget {
//   const MainNavigationScreen({super.key});

//   @override
//   State<MainNavigationScreen> createState() => _MainNavigationScreenState();
// }

// class _MainNavigationScreenState extends State<MainNavigationScreen> {
//   int _currentIndex = 0;

//   final List<Widget> _screens = const [
//     LocationPermissionGate(),
//     FavoritesScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: _currentIndex,
//         children: _screens,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) => setState(() => _currentIndex = index),
//         selectedItemColor: const Color(0xFF8D6654),
//         unselectedItemColor: Colors.grey,
//         type: BottomNavigationBarType.fixed,
//         items: [
//           BottomNavigationBarItem(
//             icon: const Icon(Icons.explore_outlined),
//             activeIcon: const Icon(Icons.explore),
//             label: AppLocale.navHome.getString(context),
//           ),
//           BottomNavigationBarItem(
//             icon: const Icon(Icons.bookmark_border_rounded),
//             activeIcon: const Icon(Icons.bookmark_rounded),
//             label: AppLocale.navMyLists.getString(context),
//           ),
//         ],
//       ),
//     );
//   }
// }
