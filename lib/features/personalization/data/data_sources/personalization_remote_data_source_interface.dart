import 'package:firebase_auth/firebase_auth.dart';
import '../models/personalization_model.dart';

abstract class PersonalizationRemoteDataSourceInterface {
  User? get currentUser;
  String? get currentUserId;

  Future<PersonalizationModel?> getUserPreferences(String userId);

  Future<void> saveUserPreferences(PersonalizationModel preferences);
}
