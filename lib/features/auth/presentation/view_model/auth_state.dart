import '../../domain/entities/user_entity.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitialState extends AuthState {
  const AuthInitialState();
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

class AuthSuccessState extends AuthState {
  final UserEntity user;
  const AuthSuccessState(this.user);
}

class OtpSentState extends AuthState {
  final String verificationId;
  final int? resendToken;

  const OtpSentState({required this.verificationId, this.resendToken});
}

class ResetPasswordEmailSentState extends AuthState {
  final String message;

  const ResetPasswordEmailSentState([
    this.message = 'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني',
  ]);
}

class UnauthenticatedState extends AuthState {
  const UnauthenticatedState();
}

class AuthErrorState extends AuthState {
  final String errorMessage;

  const AuthErrorState(this.errorMessage);
}
