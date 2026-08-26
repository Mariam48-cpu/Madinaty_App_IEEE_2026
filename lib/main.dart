import 'package:firebase_core/firebase_core.dart' hide FirebaseService;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/di/injection_container.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/features/onboarding/presentation/view_model/onboarding_bloc.dart';
import 'package:madinaty_app_ieee_2026/firebase_options.dart';
import 'package:toastification/toastification.dart';

import 'core/localization/app_locale.dart';
import 'core/routes/app_routes.dart';
import 'core/services/firebase_service.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseService.init();
  await NotificationService.instance.initialize();
  await initDependencies();

  runApp(
    BlocProvider(create: (_) => sl<OnboardingBloc>(), child: const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization _localization = FlutterLocalization.instance;

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
      ],
    );
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = _localization.currentLocale?.languageCode == 'ar';

    return ToastificationWrapper(
      child: MaterialApp(
        title: 'Madinaty',
        debugShowCheckedModeBanner: false,
        supportedLocales: _localization.supportedLocales,
        localizationsDelegates: _localization.localizationsDelegates,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        theme: AppTheme.lightTheme.copyWith(
          scaffoldBackgroundColor: AppColors.background,
        ),
        builder: (context, child) {
          return Directionality(
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
