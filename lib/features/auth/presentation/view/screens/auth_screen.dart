import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '../../../../../core/localization/app_locale.dart';
import '../../../data/data_sources/auth_data_source_imp.dart';
import '../../../data/repositories/auth_repo_imp.dart';
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('كلمتا المرور غير متطابقتين'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      context.read<AuthCubit>().processIntent(
        RegisterIntent(
          name: _nameController.text.trim(),
          email: email,
          password: password,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red.shade700,
            ),
          );
        } else if (state is AuthSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('مرحباً بك ${state.user.name ?? ""}'),
              backgroundColor: Colors.green.shade700,
            ),
          );
          // TODO: Navigation to Home Screen
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoadingState;

        return Scaffold(
          backgroundColor: const Color(0xFFF9F6F0),
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
                      // زر تبديل اللغة
                      Align(
                        alignment: Alignment.topRight,
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
                            color: Colors.black87,
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
                              color: Colors.black87,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            final localization = FlutterLocalization.instance;
                            if (localization.currentLocale?.languageCode ==
                                'ar') {
                              localization.translate('en');
                            } else {
                              localization.translate('ar');
                            }
                            setState(() {});
                          },
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
                          color: Colors.black87,
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
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        AppLocale.subtitle.getString(context),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                                      onTap: () =>
                                          setState(() => isLogin = false),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: !isLogin
                                              ? Colors.black
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
                                                : Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () =>
                                          setState(() => isLogin = true),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isLogin
                                              ? Colors.black
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
                                                : Colors.grey,
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
                                    ? AppLocale.enterEmailError.getString(
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
                                  ? 'كلمة المرور يجب أن لا تقل عن 6 أحرف'
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
                                    ? 'يرجى تأكيد كلمة المرور'
                                    : null,
                              ),
                            ],

                            if (isLogin)
                              Align(
                                alignment: Alignment.centerLeft,
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
                                      color: Colors.grey,
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
                                    horizontal: 8.0,
                                  ),
                                  child: Text(
                                    AppLocale.or.getString(context),
                                    style: const TextStyle(
                                      color: Colors.grey,
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
                                      context.read<AuthCubit>().processIntent(
                                        GoogleSignInIntent(),
                                      );
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
                                    color: Colors.black87,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    AppLocale.continueWithGoogle.getString(
                                      context,
                                    ),
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),

                            TextButton(
                              onPressed: () =>
                                  setState(() => isLogin = !isLogin),
                              child: Text(
                                isLogin
                                    ? AppLocale.noAccount.getString(context)
                                    : AppLocale.haveAccount.getString(context),
                                style: const TextStyle(
                                  color: Colors.grey,
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
