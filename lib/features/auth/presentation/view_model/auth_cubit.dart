import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/google_signin_usecase.dart';
import '../../domain/use_cases/login_usecase.dart';
import '../../domain/use_cases/logout_usecase.dart';
import '../../domain/use_cases/register_usecase.dart';
import '../../domain/use_cases/reset_password_usecase.dart';
import '../../domain/use_cases/send_otp_usecase.dart';
import '../../domain/use_cases/verify_otp_usecase.dart';
import 'auth_intent.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final SendOtpUseCase _sendOtpUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final LogoutUseCase _logoutUseCase;
  final GoogleSignInUseCase _googleSignInUseCase;

  String? currentVerificationId;
  int? currentResendToken;

  AuthCubit({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required SendOtpUseCase sendOtpUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required LogoutUseCase logoutUseCase,
    required GoogleSignInUseCase googleSignInUseCase,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _resetPasswordUseCase = resetPasswordUseCase,
       _sendOtpUseCase = sendOtpUseCase,
       _verifyOtpUseCase = verifyOtpUseCase,
       _logoutUseCase = logoutUseCase,
       _googleSignInUseCase = googleSignInUseCase,
       super(const AuthInitialState());

  void processIntent(AuthIntent intent) {
    if (intent is LoginIntent) {
      _handleLogin(intent);
    } else if (intent is RegisterIntent) {
      _handleRegister(intent);
    } else if (intent is ResetPasswordIntent) {
      _handleResetPassword(intent);
    } else if (intent is SendOtpIntent) {
      _handleSendOtp(intent);
    } else if (intent is VerifyOtpIntent) {
      _handleVerifyOtp(intent);
    } else if (intent is LogoutIntent) {
      _handleLogout();
    } else if (intent is GoogleSignInIntent) {
      _handleGoogleSignIn();
    }
  }

  Future<void> _handleLogin(LoginIntent intent) async {
    emit(const AuthLoadingState());
    try {
      final user = await _loginUseCase(
        email: intent.email,
        password: intent.password,
      );
      emit(AuthSuccessState(user));
    } catch (e) {
      emit(AuthErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _handleRegister(RegisterIntent intent) async {
    emit(const AuthLoadingState());
    try {
      final user = await _registerUseCase(
        email: intent.email,
        password: intent.password,
        name: intent.name,
        phone: intent.phone,
      );
      emit(AuthSuccessState(user));
    } catch (e) {
      emit(AuthErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _handleResetPassword(ResetPasswordIntent intent) async {
    emit(const AuthLoadingState());
    try {
      await _resetPasswordUseCase(intent.email);
      emit(const ResetPasswordEmailSentState());
    } catch (e) {
      emit(AuthErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _handleSendOtp(SendOtpIntent intent) async {
    emit(const AuthLoadingState());
    await _sendOtpUseCase(
      phoneNumber: intent.phoneNumber,
      onCodeSent: (verificationId, resendToken) {
        currentVerificationId = verificationId;
        currentResendToken = resendToken;
        emit(
          OtpSentState(
            verificationId: verificationId,
            resendToken: resendToken,
          ),
        );
      },
      onVerificationFailed: (error) {
        emit(AuthErrorState(error));
      },
    );
  }

  Future<void> _handleVerifyOtp(VerifyOtpIntent intent) async {
    if (currentVerificationId == null) {
      emit(
        const AuthErrorState(
          'لم يتم العثور على رمز التحقق، يرجى إعادة الإرسال',
        ),
      );
      return;
    }

    emit(const AuthLoadingState());
    try {
      final user = await _verifyOtpUseCase(
        verificationId: currentVerificationId!,
        smsCode: intent.smsCode,
      );
      emit(AuthSuccessState(user));
    } catch (e) {
      emit(AuthErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _handleGoogleSignIn() async {
    emit(const AuthLoadingState());
    try {
      final user = await _googleSignInUseCase();
      emit(AuthSuccessState(user));
    } catch (e) {
      emit(AuthErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _handleLogout() async {
    emit(const AuthLoadingState());
    try {
      await _logoutUseCase();
      emit(const UnauthenticatedState());
    } catch (e) {
      emit(AuthErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
