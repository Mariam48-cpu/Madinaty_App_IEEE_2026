import '../entities/user_entity.dart';
import '../repositories/auth_repo_interface.dart';

class GoogleSignInUseCase {
  final AuthRepoInterface repository;

  GoogleSignInUseCase(this.repository);

  Future<UserEntity> call() => repository.signInWithGoogle();
}
