import 'package:dartz/dartz.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../repositories/profile_repo_interface.dart';

class GetProfileUseCase {
  final ProfileRepoInterface repository;
  GetProfileUseCase(this.repository);

  Future<Either<Exception, UserEntity>> call(String uid) async {
    return await repository.getUserProfile(uid);
  }
}