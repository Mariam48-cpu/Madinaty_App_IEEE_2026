import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../domain/repositories/profile_repo_interface.dart';
import '../data_sources/profile_remote_data_source.dart';
import '../../../auth/domain/entities/user_entity.dart';

class ProfileRepoImp implements ProfileRepoInterface {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepoImp({required this.remoteDataSource});

  @override
  Future<Either<Exception, UserEntity>> getUserProfile(String uid) async {
    try {
      final userModel = await remoteDataSource.getUserProfile(uid);

      return Right(userModel);
    } catch (e) {
      return Left(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, void>> updateProfile({
    required String uid,
    required String name,
    required String phone,
    DateTime? birthDate,
    File? imageFile,
  }) async {
    try {
      await remoteDataSource.updateProfile(
        uid: uid,
        name: name,
        phone: phone,
        birthDate: birthDate,
        imageFile: imageFile,
      );

      return const Right(null);
    } catch (e) {
      return Left(e is Exception ? e : Exception(e.toString()));
    }
  }
}
