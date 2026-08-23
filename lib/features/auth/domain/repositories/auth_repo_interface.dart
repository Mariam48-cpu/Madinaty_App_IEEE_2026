import '../entities/user_entity.dart';

abstract class AuthRepoInterface {
  Future<UserEntity> register({
    required String email,
    required String password,
    required String name,
    String? phone,
  });

  Future<UserEntity> login({
    required String email,
    required String password,
  });

  Future<void> resetPassword(String email);

  Future<void> sendOtp({
    required String phoneNumber,
    required Function(
      String verificationId,
      int? resendToken,
    ) onCodeSent,
    required Function(String error)
        onVerificationFailed,
  });

  Future<UserEntity> verifyOtp({
    required String verificationId,
    required String smsCode,
  });

  Future<void> logout();

  Future<void> deleteAccount();

  bool get isAuthenticated;

  Future<UserEntity> signInWithGoogle();
}