import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:toastification/toastification.dart';

import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/routes/app_routes.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/utils/app_toast.dart';
import 'package:madinaty_app_ieee_2026/core/services/location_service.dart';

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

              // Customer
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

              // Cafe Owner
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

    Future.microtask(() async {
      if (!mounted) return;

      // ============================================================
      // GET CURRENT DEVICE LOCATION
      // ============================================================

      final locationService = LocationService();

      final position = await locationService.getCurrentLocation();

      if (!mounted) return;

      if (position == null) {
        AppToast.showToast(
          context: context,
          title: AppLocale.toastError.getString(context),
          description:
              'تعذر تحديد موقعك الحالي. تأكد من تشغيل الموقع والسماح للتطبيق باستخدامه.',
          type: ToastificationType.error,
        );

        return;
      }

      // ============================================================
      // SHOW CAFE SELECTION DIALOG
      // ============================================================

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
                      // ==================================================
                      // SEARCH
                      // ==================================================

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

                      // ==================================================
                      // CAFES
                      // ==================================================
                      Expanded(
                        child: FutureBuilder<List<CafeEntity>>(
                          future: getNearbyCafesUseCase(
                            // IMPORTANT:
                            // Use CURRENT DEVICE LOCATION
                            // instead of fixed coordinates.
                            latitude: position.latitude,
                            longitude: position.longitude,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              );
                            }

                            if (snapshot.hasError) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    snapshot.error.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              );
                            }

                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(
                                child: Text(
                                  AppLocale.noReservationsFound.getString(
                                    context,
                                  ),
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
                              return Center(
                                child: Text(
                                  AppLocale.noResultsFound.getString(context),
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
                                      Navigator.of(dialogContext).pop();

                                      // ==========================================
                                      // SAVE SELECTED CAFE
                                      // ==========================================

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

                                      // ==========================================
                                      // AUTHENTICATION
                                      // ==========================================

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

              // Customer
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

              // Cafe Owner
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
        } else if (state is AuthSuccessState) {
          final userName = state.user.name ?? '';

          AppToast.showToast(
            context: context,
            title: AppLocale.toastSuccess.getString(context),
            description:
                '${AppLocale.welcomeUserPrefix.getString(context)} $userName',
            type: ToastificationType.success,
          );

          // ============================================================
          // NAVIGATION AFTER AUTH
          // ============================================================

          if (state.user.isCafeOwner) {
            // Cafe Owner -> Owner Dashboard
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.ownerDashboard,
              arguments: state.user.cafeId,
            );
          } else {
            // Customer
            Navigator.pushReplacementNamed(
              context,
              isLogin ? AppRoutes.home : AppRoutes.personalization,
            );
          }

          // IMPORTANT:
          // Removed the old unconditional navigation to Personalization.
          //
          // The old code was doing:
          //
          // Navigator.pushReplacementNamed(
          //   context,
          //   AppRoutes.personalization,
          // );
          //
          // after already navigating the Cafe Owner to OwnerDashboard.
          // That could override the Owner Dashboard navigation.
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoadingState;

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
                      // ======================================================
                      // LANGUAGE
                      // ======================================================

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
                            FlutterLocalization
                                        .instance
                                        .currentLocale
                                        ?.languageCode ==
                                    'ar'
                                ? 'English'
                                : 'العربية',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            final localization = FlutterLocalization.instance;

                            final currentLanguage =
                                localization.currentLocale?.languageCode;

                            if (currentLanguage == 'ar') {
                              localization.translate('en');
                            } else {
                              localization.translate('ar');
                            }

                            setState(() {});
                          },
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ======================================================
                      // ICON
                      // ======================================================
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

                      // ======================================================
                      // TITLE
                      // ======================================================
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

                      // ======================================================
                      // AUTH CARD
                      // ======================================================
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            // ==================================================
                            // LOGIN / REGISTER TABS
                            // ==================================================

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

                            // ==================================================
                            // NAME
                            // ==================================================
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

                            // ==================================================
                            // EMAIL / PHONE
                            // ==================================================
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

                            // ==================================================
                            // PASSWORD
                            // ==================================================
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

                            // ==================================================
                            // CONFIRM PASSWORD
                            // ==================================================
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

                            // ==================================================
                            // FORGOT PASSWORD
                            // ==================================================
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

                            // ==================================================
                            // SUBMIT
                            // ==================================================
                            CustomAuthButton(
                              text: isLogin
                                  ? AppLocale.login.getString(context)
                                  : AppLocale.register.getString(context),
                              isLoading: isLoading,
                              onPressed: _submit,
                            ),

                            const SizedBox(height: 16),

                            // ==================================================
                            // OR
                            // ==================================================
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

                            // ==================================================
                            // GOOGLE
                            // ==================================================
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

                            // ==================================================
                            // SWITCH LOGIN / REGISTER
                            // ==================================================
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
