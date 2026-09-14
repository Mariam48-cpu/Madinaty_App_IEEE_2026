import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:geolocator/geolocator.dart';
import 'package:toastification/toastification.dart';

import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/routes/app_routes.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/utils/app_toast.dart';

import '../../../../../core/di/injection.dart';
import '../../../../cafe/data/data_sources/cafe_firestore_data_source.dart';
import '../../../../discovery/data/data_sources/google_places_datasource.dart';
import '../../../../discovery/data/repositories/cafe_repository_impl.dart';
import '../../../../discovery/domain/entities/cafe_entity.dart';
import '../../../../discovery/domain/use_cases/get_nearby_cafes.dart';

import '../../../data/data_sources/auth_data_source_imp.dart';
import '../../../data/repositories/auth_repo_imp.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/use_cases/google_signin_usecase.dart';
import '../../../domain/use_cases/login_usecase.dart';
import '../../../domain/use_cases/logout_usecase.dart';
import '../../../domain/use_cases/register_usecase.dart';
import '../../../domain/use_cases/reset_password_usecase.dart';
import '../../../domain/use_cases/send_otp_usecase.dart';
import '../../../domain/use_cases/verify_otp_usecase.dart';

import '../../view_model/auth_cubit.dart';
import '../../view_model/auth_intent.dart';
import '../../view_model/auth_state.dart';

import '../widgets/custom_auth_button.dart';
import '../widgets/custom_text_field.dart';
import 'forget_password_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataSource = AuthRemoteDataSourceImpl();
    final repository = AuthRepoImpl(remoteDataSource: dataSource);

    return BlocProvider(
      create: (context) => AuthCubit(
        loginUseCase: LoginUseCase(repository),
        registerUseCase: RegisterUseCase(repository),
        resetPasswordUseCase: ResetPasswordUseCase(repository),
        sendOtpUseCase: SendOtpUseCase(repository),
        verifyOtpUseCase: VerifyOtpUseCase(repository),
        logoutUseCase: LogoutUseCase(repository),
        googleSignInUseCase: GoogleSignInUseCase(repository),
      ),
      child: const _AuthScreenBody(),
    );
  }
}

class _AuthScreenBody extends StatefulWidget {
  const _AuthScreenBody();

  @override
  State<_AuthScreenBody> createState() => _AuthScreenBodyState();
}

class _AuthScreenBodyState extends State<_AuthScreenBody> {
  bool isLogin = true;

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailOrPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _toggleLanguage() {
    final localization = FlutterLocalization.instance;
    final currentLanguage = localization.currentLocale?.languageCode ?? 'ar';

    if (currentLanguage == 'ar') {
      localization.translate('en');
    } else {
      localization.translate('ar');
    }

    setState(() {});
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailOrPhoneController.text.trim();
    final password = _passwordController.text.trim();

    if (isLogin) {
      context.read<AuthCubit>().processIntent(
        LoginIntent(email: email, password: password),
      );
    } else {
      if (_passwordController.text != _confirmPasswordController.text) {
        AppToast.showToast(
          context: context,
          title: AppLocale.toastError.getString(context),
          description: AppLocale.passwordMismatchError.getString(context),
          type: ToastificationType.error,
        );
        return;
      }

      _showRoleSelectionDialog(
        name: _nameController.text.trim(),
        email: email,
        password: password,
      );
    }
  }

  void _showRoleSelectionDialog({
    required String name,
    required String email,
    required String password,
  }) {
    final authCubit = context.read<AuthCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            AppLocale.accountTypeTitle.getString(context),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocale.accountTypeSubtitle.getString(context),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 18),

              ListTile(
                tileColor: const Color(0xFFF5F1EC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: const Icon(
                  Icons.person_pin,
                  color: AppColors.textPrimary,
                ),
                title: Text(
                  AppLocale.customerRoleTitle.getString(context),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  AppLocale.customerRoleSubtitle.getString(context),
                ),
                onTap: () {
                  Navigator.pop(dialogContext);

                  authCubit.processIntent(
                    RegisterIntent(
                      name: name,
                      email: email,
                      password: password,
                      role: UserRole.customer,
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),

              ListTile(
                tileColor: const Color(0xFFF5F1EC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: const Icon(
                  Icons.storefront,
                  color: AppColors.textPrimary,
                ),
                title: Text(
                  AppLocale.cafeOwnerRoleTitle.getString(context),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  AppLocale.cafeOwnerRoleSubtitle.getString(context),
                ),
                onTap: () {
                  Navigator.pop(dialogContext);

                  _showCafeSelectionDialog(
                    name: name,
                    email: email,
                    password: password,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCafeSelectionDialog({
    required String name,
    required String email,
    required String password,
    bool isGoogle = false,
  }) {
    GetNearbyCafes getNearbyCafesUseCase;

    try {
      getNearbyCafesUseCase = getIt<GetNearbyCafes>();
    } catch (_) {
      getNearbyCafesUseCase = GetNearbyCafes(
        CafeRepositoryImpl(
          googlePlacesDataSource: GooglePlacesDataSource(),
          firebaseDataSource: CafeFirestoreDataSource(),
        ),
      );
    }

    final authCubit = context.read<AuthCubit>();
    final searchController = TextEditingController();

    Future<Position?> getCurrentLocation() async {
      try {
        // 1. Check if GPS / Location Service is enabled
        final serviceEnabled = await Geolocator.isLocationServiceEnabled();

        if (!serviceEnabled) {
          if (!mounted) return null;

          final shouldOpenSettings = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: const Text(
                  'الموقع غير مفعل',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                content: const Text(
                  'لازم تفعّل خدمة الموقع على جهازك علشان نقدر نجيب الكافيهات القريبة منك.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext, false);
                    },
                    child: const Text('إلغاء'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext, true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text(
                      'تفعيل الموقع',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          );

          if (shouldOpenSettings == true) {
            await Geolocator.openLocationSettings();

            // بعد ما يرجع من Settings، نتأكد إن الـ GPS اتفتح
            final enabledAgain = await Geolocator.isLocationServiceEnabled();

            if (!enabledAgain) {
              return null;
            }
          } else {
            return null;
          }
        }

        // 2. Check location permission
        LocationPermission permission = await Geolocator.checkPermission();

        // 3. Request permission if it hasn't been granted
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();

          if (permission == LocationPermission.denied) {
            if (!mounted) return null;

            await showDialog(
              context: context,
              builder: (dialogContext) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: const Text(
                    'صلاحية الموقع مطلوبة',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  content: const Text(
                    'لازم تسمح للتطبيق بالوصول إلى موقعك علشان نعرض الكافيهات القريبة منك.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  actionsAlignment: MainAxisAlignment.center,
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                      child: const Text('حسنًا'),
                    ),
                  ],
                );
              },
            );

            return null;
          }
        }

        // 4. Permission was permanently denied
        if (permission == LocationPermission.deniedForever) {
          if (!mounted) return null;

          final shouldOpenSettings = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: const Text(
                  'صلاحية الموقع مرفوضة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                content: const Text(
                  'صلاحية الموقع تم رفضها نهائيًا. افتح إعدادات التطبيق واسمح بالوصول إلى الموقع.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext, false);
                    },
                    child: const Text('إلغاء'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext, true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text(
                      'فتح الإعدادات',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          );

          if (shouldOpenSettings == true) {
            await Geolocator.openAppSettings();

            // بعد الرجوع من Settings، نتحقق مرة أخرى
            permission = await Geolocator.checkPermission();

            if (permission == LocationPermission.denied ||
                permission == LocationPermission.deniedForever) {
              return null;
            }
          } else {
            return null;
          }
        }

        // 5. Get the REAL current location
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        );

        return position;
      } catch (e) {
        if (!mounted) return null;

        await showDialog(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'حدث خطأ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              content: Text(
                'لم نتمكن من الحصول على موقعك الحالي.\n\n$e',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('حسنًا'),
                ),
              ],
            );
          },
        );

        return null;
      }
    }

    Future.microtask(() async {
      if (!mounted) return;

      // ---------------------------------------------------------
      // Get current location BEFORE opening the cafe selection
      // ---------------------------------------------------------

      final position = await getCurrentLocation();

      if (!mounted) return;

      if (position == null) {
        return;
      }

      final currentLatitude = position.latitude;
      final currentLongitude = position.longitude;

      debugPrint(
        'Owner Current Location: '
        '$currentLatitude, $currentLongitude',
      );

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  AppLocale.cafeLabel.getString(context),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                content: SizedBox(
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height * 0.55,
                  child: Column(
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: AppLocale.digitalPassSearchHint.getString(
                            context,
                          ),
                          prefixIcon: const Icon(Icons.search, size: 20),
                          filled: true,
                          fillColor: const Color(0xFFF5F1EC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                        ),
                        onChanged: (_) {
                          setModalState(() {});
                        },
                      ),

                      const SizedBox(height: 10),

                      Expanded(
                        child: FutureBuilder<List<CafeEntity>>(
                          future: getNearbyCafesUseCase(
                            latitude: currentLatitude,
                            longitude: currentLongitude,
                          ),
                          builder: (context, snapshot) {
                            // Loading
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              );
                            }

                            // Error
                            if (snapshot.hasError) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.location_off,
                                        color: Colors.red,
                                        size: 35,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'حدث خطأ أثناء جلب الكافيهات القريبة.',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.red,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        snapshot.error.toString(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            // No cafes
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(
                                child: Text(
                                  AppLocale.noReservationsFound.getString(
                                    context,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }

                            final allCafes = snapshot.data!;

                            final query = searchController.text
                                .trim()
                                .toLowerCase();

                            final cafes = query.isEmpty
                                ? allCafes
                                : allCafes
                                      .where(
                                        (cafe) => cafe.name
                                            .toLowerCase()
                                            .contains(query),
                                      )
                                      .toList();

                            if (cafes.isEmpty) {
                              return const Center(
                                child: Text(
                                  'لا يوجد كافيه بهذا الاسم.',
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }

                            return Scrollbar(
                              thumbVisibility: true,
                              child: ListView.separated(
                                itemCount: cafes.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 8),
                                itemBuilder: (context, index) {
                                  final cafe = cafes[index];

                                  return ListTile(
                                    tileColor: const Color(0xFFF5F1EC),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    leading: const CircleAvatar(
                                      backgroundColor: Color(0xFFEBE3D8),
                                      child: Icon(
                                        Icons.storefront,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    title: Text(
                                      cafe.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    subtitle: Text(
                                      cafe.address.isNotEmpty
                                          ? cafe.address
                                          : 'بنها، الفلل',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    onTap: () async {
                                      // Close cafe selection dialog
                                      Navigator.of(dialogContext).pop();

                                      // Save/update cafe in Firestore
                                      await FirebaseFirestore.instance
                                          .collection('cafes')
                                          .doc(cafe.id)
                                          .set({
                                            'name': cafe.name,
                                            'address': cafe.address.isNotEmpty
                                                ? cafe.address
                                                : 'بنها، الفلل',
                                            'latitude': cafe.latitude,
                                            'longitude': cafe.longitude,
                                            'updatedAt':
                                                FieldValue.serverTimestamp(),
                                          }, SetOptions(merge: true));

                                      // Continue authentication flow
                                      if (isGoogle) {
                                        authCubit.processIntent(
                                          GoogleSignInIntent(
                                            role: UserRole.cafeOwner,
                                            cafeId: cafe.id,
                                          ),
                                        );
                                      } else {
                                        authCubit.processIntent(
                                          RegisterIntent(
                                            name: name,
                                            email: email,
                                            password: password,
                                            role: UserRole.cafeOwner,
                                            cafeId: cafe.id,
                                          ),
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    });
  }

  void _showGoogleRoleSelectionDialog() {
    final authCubit = context.read<AuthCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            AppLocale.accountTypeTitle.getString(context),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocale.accountTypeSubtitle.getString(context),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 18),

              ListTile(
                tileColor: const Color(0xFFF5F1EC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: const Icon(
                  Icons.person_pin,
                  color: AppColors.textPrimary,
                ),
                title: Text(
                  AppLocale.customerRoleTitle.getString(context),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  AppLocale.customerRoleSubtitle.getString(context),
                ),
                onTap: () {
                  Navigator.pop(dialogContext);

                  authCubit.processIntent(
                    GoogleSignInIntent(role: UserRole.customer),
                  );
                },
              ),

              const SizedBox(height: 10),

              ListTile(
                tileColor: const Color(0xFFF5F1EC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: const Icon(
                  Icons.storefront,
                  color: AppColors.textPrimary,
                ),
                title: Text(
                  AppLocale.cafeOwnerRoleTitle.getString(context),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  AppLocale.cafeOwnerRoleSubtitle.getString(context),
                ),
                onTap: () {
                  Navigator.pop(dialogContext);

                  _showCafeSelectionDialog(
                    name: '',
                    email: '',
                    password: '',
                    isGoogle: true,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthErrorState) {
          AppToast.showToast(
            context: context,
            title: AppLocale.toastError.getString(context),
            description: state.errorMessage,
            type: ToastificationType.error,
          );
        }

        if (state is AuthSuccessState) {
          final userName = state.user.name ?? '';

          AppToast.showToast(
            context: context,
            title: AppLocale.toastSuccess.getString(context),
            description:
                '${AppLocale.welcomeUserPrefix.getString(context)} $userName',
            type: ToastificationType.success,
          );

          // Cafe owner
          if (state.user.isCafeOwner) {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.ownerDashboard,
              arguments: state.user.cafeId,
            );
            return;
          }

          // Customer:
          // Register -> Personalization
          // Login -> Home
          if (isLogin) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          } else {
            Navigator.pushReplacementNamed(context, AppRoutes.personalization);
          }
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoadingState;

        final localization = FlutterLocalization.instance;

        final isArabic = localization.currentLocale?.languageCode == 'ar';

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFFEBE3D8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                          ),
                          icon: const Icon(
                            Icons.language,
                            size: 18,
                            color: AppColors.textPrimary,
                          ),
                          label: Text(
                            isArabic ? 'English' : 'العربية',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: _toggleLanguage,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFFEBE3D8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.local_cafe,
                          color: AppColors.textPrimary,
                          size: 28,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        isLogin
                            ? AppLocale.welcome.getString(context)
                            : AppLocale.register.getString(context),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        AppLocale.subtitle.getString(context),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F1EC),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isLogin = false;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: !isLogin
                                              ? AppColors.textPrimary
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          AppLocale.register.getString(context),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: !isLogin
                                                ? Colors.white
                                                : AppColors.textSecondary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isLogin = true;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isLogin
                                              ? AppColors.textPrimary
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          AppLocale.login.getString(context),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: isLogin
                                                ? Colors.white
                                                : AppColors.textSecondary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            if (!isLogin) ...[
                              CustomTextField(
                                controller: _nameController,
                                label: AppLocale.name.getString(context),
                                hint: AppLocale.nameHint.getString(context),
                                suffixIcon: Icons.person_outline,
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? AppLocale.enterNameError.getString(
                                        context,
                                      )
                                    : null,
                              ),
                              const SizedBox(height: 14),
                            ],

                            CustomTextField(
                              controller: _emailOrPhoneController,
                              label: AppLocale.emailOrPhone.getString(context),
                              hint: AppLocale.emailHint.getString(context),
                              suffixIcon: isLogin
                                  ? Icons.person_outline
                                  : Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? AppLocale.enterEmailError.getString(context)
                                  : null,
                            ),

                            const SizedBox(height: 14),

                            CustomTextField(
                              controller: _passwordController,
                              label: AppLocale.password.getString(context),
                              hint: AppLocale.passwordHint.getString(context),
                              isPassword: true,
                              validator: (v) => (v == null || v.length < 6)
                                  ? AppLocale.passwordMinLengthError.getString(
                                      context,
                                    )
                                  : null,
                            ),

                            if (!isLogin) ...[
                              const SizedBox(height: 14),

                              CustomTextField(
                                controller: _confirmPasswordController,
                                label: AppLocale.confirmPassword.getString(
                                  context,
                                ),
                                hint: AppLocale.confirmPasswordHint.getString(
                                  context,
                                ),
                                isPassword: true,
                                validator: (v) => (v == null || v.isEmpty)
                                    ? AppLocale.confirmPasswordRequiredError
                                          .getString(context)
                                    : null,
                              ),
                            ],

                            if (isLogin)
                              Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BlocProvider.value(
                                          value: context.read<AuthCubit>(),
                                          child: const ForgotPasswordScreen(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    AppLocale.forgotPassword.getString(context),
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),

                            const SizedBox(height: 16),

                            CustomAuthButton(
                              text: isLogin
                                  ? AppLocale.login.getString(context)
                                  : AppLocale.register.getString(context),
                              isLoading: isLoading,
                              onPressed: _submit,
                            ),

                            const SizedBox(height: 16),

                            Row(
                              children: [
                                const Expanded(child: Divider()),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    AppLocale.or.getString(context),
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const Expanded(child: Divider()),
                              ],
                            ),

                            const SizedBox(height: 16),

                            OutlinedButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      if (isLogin) {
                                        context.read<AuthCubit>().processIntent(
                                          GoogleSignInIntent(),
                                        );
                                      } else {
                                        _showGoogleRoleSelectionDialog();
                                      }
                                    },
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.g_mobiledata,
                                    size: 24,
                                    color: AppColors.textPrimary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    AppLocale.continueWithGoogle.getString(
                                      context,
                                    ),
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isLogin = !isLogin;
                                });
                              },
                              child: Text(
                                isLogin
                                    ? AppLocale.noAccount.getString(context)
                                    : AppLocale.haveAccount.getString(context),
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
