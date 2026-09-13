import '../../domain/entities/user_entity.dart';

abstract class AuthIntent {}

class LoginIntent extends AuthIntent {
  final String email;
  final String password;
  LoginIntent({required this.email, required this.password});
}

class RegisterIntent extends AuthIntent {
  final String email;
  final String password;
  final UserRole role;
  final String name;
  final String? phone;
  final String? cafeId; // 👈 إضافة cafeId هنا

  RegisterIntent({
    required this.email,
    required this.password,
    this.role = UserRole.customer,
    required this.name,
    this.phone,
    this.cafeId,
  });
}

class ResetPasswordIntent extends AuthIntent {
  final String email;
  ResetPasswordIntent(this.email);
}

class SendOtpIntent extends AuthIntent {
  final String phoneNumber;
  SendOtpIntent(this.phoneNumber);
}

class VerifyOtpIntent extends AuthIntent {
  final String smsCode;
  VerifyOtpIntent(this.smsCode);
}

class LogoutIntent extends AuthIntent {}

class GoogleSignInIntent extends AuthIntent {
  final UserRole? role;
  final String? cafeId;

  GoogleSignInIntent({this.role, this.cafeId});
}