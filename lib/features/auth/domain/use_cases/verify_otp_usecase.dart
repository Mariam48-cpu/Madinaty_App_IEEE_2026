import '../entities/user_entity.dart';
import '../repositories/auth_repo_interface.dart';

class VerifyOtpUseCase {
  final AuthRepoInterface repository;

  VerifyOtpUseCase(this.repository);

  Future<UserEntity> call({
    required String verificationId,
    required String smsCode,
  }) => repository.verifyOtp(verificationId: verificationId, smsCode: smsCode);
}
