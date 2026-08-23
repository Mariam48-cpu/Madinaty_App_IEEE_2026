import 'dart:io';

import 'package:dartz/dartz.dart';

import '../repositories/profile_repo_interface.dart';

class UpdateProfileUseCase {
  final ProfileRepoInterface repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Exception, void>> call({
    required String uid,
    required String name,
    required String phone,
    DateTime? birthDate,
    File? imageFile,
  }) async {
    return await repository.updateProfile(
      uid: uid,
      name: name,
      phone: phone,
      birthDate: birthDate,
      imageFile: imageFile,
    );
  }
}