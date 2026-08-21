import '../entities/user_entity.dart';
import '../repositories/auth_repo_interface.dart';

class RegisterUseCase {
  final AuthRepoInterface repository;

  RegisterUseCase(this.repository);

  Future<UserEntity> call({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) => repository.register(
    email: email,
    password: password,
    name: name,
    phone: phone,
  );
}
