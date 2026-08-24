import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/personalization_entity.dart';
import '../../domain/repositories/personalization_repository_interface.dart';
import '../data_sources/personalization_remote_data_source_interface.dart';
import '../models/personalization_model.dart';

@LazySingleton(as: PersonalizationRepositoryInterface)
class PersonalizationRepoImpl implements PersonalizationRepositoryInterface {
  final PersonalizationRemoteDataSourceInterface _remoteDataSource;

  PersonalizationRepoImpl({
    required PersonalizationRemoteDataSourceInterface remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<PersonalizationEntity?> getUserPreferences(String userId) async {
    try {
      return await _remoteDataSource.getUserPreferences(userId);
    } on FirebaseException catch (e) {
      throw Exception(e.message ?? 'فشل في استرجاع التفضيلات');
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع: $e');
    }
  }

  @override
  Future<void> saveUserPreferences(PersonalizationEntity preferences) async {
    try {
      final model = PersonalizationModel.fromEntity(preferences);

      await _remoteDataSource.saveUserPreferences(model);
    } on FirebaseException catch (e) {
      throw Exception(e.message ?? 'فشل في حفظ التفضيلات');
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع: $e');
    }
  }
}