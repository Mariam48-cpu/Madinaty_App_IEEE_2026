abstract class AuthIntent {}

class LoginIntent extends AuthIntent {
  final String email;
  final String password;
  LoginIntent({required this.email, required this.password});
}

class RegisterIntent extends AuthIntent {
  final String email;
  final String password;
  final String name;
  final String? phone;
  RegisterIntent({
    required this.email,
    required this.password,
    required this.name,
    this.phone,
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

class GoogleSignInIntent extends AuthIntent {}
