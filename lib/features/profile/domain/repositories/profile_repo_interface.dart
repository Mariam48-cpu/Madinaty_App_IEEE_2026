import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../auth/domain/entities/user_entity.dart';

abstract class ProfileRepoInterface {
  Future<Either<Exception, UserEntity>> getUserProfile(String uid);

  Future<Either<Exception, void>> updateProfile({
    required String uid,
    required String name,
    required String phone,
    DateTime? birthDate,
    File? imageFile,
  });
}