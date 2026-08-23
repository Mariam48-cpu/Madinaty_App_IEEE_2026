import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

abstract class AuthRemoteDataSourceInterface {
  Future<UserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    String? phone,
  });

  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> sendPasswordResetEmail(String email);

  Future<void> sendPhoneOtp({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) onCodeSent,
    required Function(FirebaseAuthException error) onVerificationFailed,
    required Function(PhoneAuthCredential credential)
        onVerificationCompleted,
    required Function(String verificationId)
        onCodeAutoRetrievalTimeout,
  });

  Future<UserModel> verifyOtpAndSignIn({
    required String verificationId,
    required String smsCode,
  });

  Future<void> signOut();

  Future<void> deleteAccount();

  User? get currentUser;

  Future<UserModel> signInWithGoogle();
}