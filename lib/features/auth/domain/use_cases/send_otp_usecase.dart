import '../repositories/auth_repo_interface.dart';

class SendOtpUseCase {
  final AuthRepoInterface repository;

  SendOtpUseCase(this.repository);

  Future<void> call({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) onCodeSent,
    required Function(String error) onVerificationFailed,
  }) => repository.sendOtp(
    phoneNumber: phoneNumber,
    onCodeSent: onCodeSent,
    onVerificationFailed: onVerificationFailed,
  );
}
