import '../repositories/auth_repo_interface.dart';

class ResetPasswordUseCase {
  final AuthRepoInterface repository;

  ResetPasswordUseCase(this.repository);

  Future<void> call(String email) => repository.resetPassword(email);
}
