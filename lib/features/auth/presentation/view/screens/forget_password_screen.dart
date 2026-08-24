import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/utils/app_toast.dart';
import 'package:toastification/toastification.dart';
import '../../../../../core/localization/app_locale.dart';
import '../../view_model/auth_cubit.dart';
import '../../view_model/auth_intent.dart';
import '../../view_model/auth_state.dart';
import '../widgets/custom_auth_button.dart';
import '../widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onResetPressed() {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    context.read<AuthCubit>().processIntent(ResetPasswordIntent(email));
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
        } else if (state is ResetPasswordEmailSentState) {
          AppToast.showToast(
            context: context,
            title: AppLocale.toastSuccess.getString(context),
            description: AppLocale.resetLinkSentSuccess.getString(context),
            type: ToastificationType.success,
          );
          Navigator.pop(context);
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
                  vertical: 24,
                ),
                child: Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: const BoxDecoration(
                            color: Color(0xFFEBE3D8),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.rotate_left_rounded,
                            color: AppColors.textPrimary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocale.forgotPassword.getString(context),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocale.forgotPasswordDesc.getString(context),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),
                        CustomTextField(
                          controller: _emailController,
                          label: AppLocale.emailOrPhone.getString(context),
                          hint: AppLocale.emailHint.getString(context),
                          keyboardType: TextInputType.emailAddress,
                          suffixIcon: Icons.email_outlined,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return AppLocale.enterEmailError.getString(
                                context,
                              );
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        CustomAuthButton(
                          text: AppLocale.sendResetLink.getString(context),
                          isLoading: isLoading,
                          onPressed: _onResetPressed,
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            AppLocale.backToLogin.getString(context),
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
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