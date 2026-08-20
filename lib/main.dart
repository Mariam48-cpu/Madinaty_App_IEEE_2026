import 'package:firebase_core/firebase_core.dart' hide FirebaseService;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';

import 'package:madinaty_app_ieee_2026/core/di/injection.dart';
import 'package:madinaty_app_ieee_2026/features/auth/presentation/view/screens/auth_screen.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/screens/location_permission_gate.dart';
import 'package:madinaty_app_ieee_2026/firebase_options.dart';

import 'core/di/injection.dart';
import 'core/di/injection_container.dart';
import 'core/localization/app_locale.dart';
import 'core/routes/app_routes.dart';
import 'core/services/firebase_service.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/presentation/view/screens/splash_screen.dart';
import 'features/onboarding/presentation/view_model/onboarding_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseService.init();
  configureDependencies();
  await initDependencies();

  runApp(
    BlocProvider(
      create: (_) => sl<OnboardingBloc>(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization _localization =
      FlutterLocalization.instance;

  @override
  void initState() {
    super.initState();

    _localization.onTranslatedLanguage = _onTranslatedLanguage;

    _initializeLocalization();
  }

  void _initializeLocalization() {
    _localization.init(
      initLanguageCode: 'ar',
      mapLocales: [
        const MapLocale(
          'ar',
          AppLocale.AR,
          countryCode: 'EG',
          fontFamily: 'Cairo',
        ),
        const MapLocale(
          'en',
          AppLocale.EN,
          countryCode: 'US',
          fontFamily: 'Cairo',
        ),
        const MapLocale(
          'km',
          AppLocale.KM,
          countryCode: 'KH',
        ),
        const MapLocale(
          'ja',
          AppLocale.JA,
          countryCode: 'JP',
        ),
      ],
    );
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isArabic =
        _localization.currentLocale?.languageCode == 'ar';

    return MaterialApp(
      title: 'Madinaty',
      debugShowCheckedModeBanner: false,

      supportedLocales: _localization.supportedLocales,
      localizationsDelegates:
          _localization.localizationsDelegates,

      theme: AppTheme.lightTheme,

      builder: (context, child) {
        return Directionality(
          textDirection:
              isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: child ?? const SizedBox.shrink(),
        );
      },

      home: const SplashScreen(),

      home: const AuthScreen(),
    );
  }
}