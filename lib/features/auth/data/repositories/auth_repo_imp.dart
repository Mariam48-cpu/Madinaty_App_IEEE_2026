import 'package:firebase_auth/firebase_auth.dart';
import 'package:madinaty_app_ieee_2026/features/auth/data/data_sources/auth_data_source_interface.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repo_interface.dart';

class AuthRepoImpl implements AuthRepoInterface {
  final AuthRemoteDataSourceInterface _remoteDataSource;

  AuthRepoImpl({
    required AuthRemoteDataSourceInterface remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  bool get isAuthenticated =>
      _remoteDataSource.currentUser != null;

  // ==================================================
  // REGISTER
  // ==================================================

  @override
  Future<UserEntity> register({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    try {
      return await _remoteDataSource
          .registerWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(
        _handleFirebaseAuthException(e),
      );
    } catch (e) {
      throw Exception(
        'حدث خطأ غير متوقع: $e',
      );
    }
  }

  // ==================================================
  // LOGIN
  // ==================================================

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      return await _remoteDataSource
          .loginWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(
        _handleFirebaseAuthException(e),
      );
    } catch (e) {
      throw Exception(
        'حدث خطأ غير متوقع: $e',
      );
    }
  }

  // ==================================================
  // RESET PASSWORD
  // ==================================================

  @override
  Future<void> resetPassword(
    String email,
  ) async {
    try {
      await _remoteDataSource
          .sendPasswordResetEmail(email);
    } on FirebaseAuthException catch (e) {
      throw Exception(
        _handleFirebaseAuthException(e),
      );
    } catch (e) {
      throw Exception(
        'حدث خطأ غير متوقع: $e',
      );
    }
  }

  // ==================================================
  // SEND OTP
  // ==================================================

  @override
  Future<void> sendOtp({
    required String phoneNumber,
    required Function(
      String verificationId,
      int? resendToken,
    ) onCodeSent,
    required Function(String error)
        onVerificationFailed,
  }) async {
    await _remoteDataSource.sendPhoneOtp(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onVerificationFailed: (error) {
        onVerificationFailed(
          _handleFirebaseAuthException(error),
        );
      },
      onVerificationCompleted: (_) {},
      onCodeAutoRetrievalTimeout: (_) {},
    );
  }

  // ==================================================
  // VERIFY OTP
  // ==================================================

  @override
  Future<UserEntity> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      return await _remoteDataSource
          .verifyOtpAndSignIn(
        verificationId: verificationId,
        smsCode: smsCode,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(
        _handleFirebaseAuthException(e),
      );
    } catch (e) {
      throw Exception(
        'حدث خطأ غير متوقع: $e',
      );
    }
  }

  // ==================================================
  // LOGOUT
  // ==================================================

  @override
  Future<void> logout() async {
    await _remoteDataSource.signOut();
  }

  // ==================================================
  // DELETE ACCOUNT
  // ==================================================

  @override
  Future<void> deleteAccount() async {
    try {
      await _remoteDataSource.deleteAccount();
    } on FirebaseAuthException catch (e) {
      throw Exception(
        _handleFirebaseAuthException(e),
      );
    } catch (e) {
      throw Exception(
        e.toString().replaceAll(
              'Exception: ',
              '',
            ),
      );
    }
  }

  // ==================================================
  // FIREBASE ERROR HANDLER
  // ==================================================

  String _handleFirebaseAuthException(
    FirebaseAuthException e,
  ) {
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';

      case 'email-already-in-use':
        return 'البريد الإلكتروني مستخدم بالفعل بحساب آخر';

      case 'invalid-email':
        return 'صيغة البريد الإلكتروني غير صحيحة';

      case 'weak-password':
        return 'كلمة المرور ضعيفة جداً';

      case 'invalid-verification-code':
        return 'رمز التحقق (OTP) غير صحيح';

      case 'session-expired':
        return 'انتهت صلاحية رمز التحقق، يرجى إعادة المحاولة';

      case 'requires-recent-login':
        return 'لأسباب أمنية، يرجى تسجيل الدخول مرة أخرى ثم محاولة حذف الحساب';

      default:
        return e.message ??
            'حدث خطأ في عملية تسجيل الدخول';
    }
  }

  // ==================================================
  // GOOGLE SIGN IN
  // ==================================================

  @override
  Future<UserEntity> signInWithGoogle() async {
    try {
      return await _remoteDataSource
          .signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      throw Exception(
        _handleFirebaseAuthException(e),
      );
    } catch (e) {
      throw Exception(
        e.toString().replaceAll(
              'Exception: ',
              '',
            ),
      );
    }
  }
}