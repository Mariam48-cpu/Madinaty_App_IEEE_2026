import '../repositories/auth_repo_interface.dart';

class LogoutUseCase {
  final AuthRepoInterface repository;

  LogoutUseCase(this.repository);

  Future<void> call() => repository.logout();
}
