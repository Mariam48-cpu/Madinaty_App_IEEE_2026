import '../entities/user_entity.dart';
import '../repositories/auth_repo_interface.dart';

class LoginUseCase {
  final AuthRepoInterface repository;

  LoginUseCase(this.repository);

  Future<UserEntity> call({required String email, required String password}) =>
      repository.login(email: email, password: password);
}
