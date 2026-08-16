import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:madinaty_app_ieee_2026/core/di/injection.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/screens/explore_map_screen.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view_model/cubit/discovery_cubit.dart';
import 'package:madinaty_app_ieee_2026/firebase_options.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Madinaty',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      initialRoute: AppRoutes.initial,
      onGenerateRoute: AppRoutes.onGenerateRoute,

      locale: const Locale('ar'),

      supportedLocales: const [Locale('ar'), Locale('en')],

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: ExploreMapScreen(cubit: getIt<DiscoveryCubit>()),
    );
  }
}
