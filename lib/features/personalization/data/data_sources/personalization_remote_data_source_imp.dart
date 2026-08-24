import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../models/personalization_model.dart';
import 'personalization_remote_data_source_interface.dart';

@LazySingleton(as: PersonalizationRemoteDataSourceInterface)
class PersonalizationRemoteDataSourceImpl
    implements PersonalizationRemoteDataSourceInterface {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  PersonalizationRemoteDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  String? get currentUserId => _firebaseAuth.currentUser?.uid;

  @override
  Future<PersonalizationModel?> getUserPreferences(String userId) async {
    final targetId = userId.isNotEmpty ? userId : currentUserId;
    if (targetId == null || targetId.isEmpty) {
      return null;
    }

    final doc = await _firestore.collection('users').doc(targetId).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return PersonalizationModel.fromMap(doc.data()!, doc.id);
  }

  @override
  Future<void> saveUserPreferences(PersonalizationModel preferences) async {
    final uid = preferences.userId.isNotEmpty
        ? preferences.userId
        : currentUserId;

    if (uid == null || uid.isEmpty) {
      throw Exception('المستخدم غير مسجل الدخول');
    }

    final dataToSave = preferences.toMap();
    dataToSave['updatedAt'] ??= Timestamp.now();

    await _firestore
        .collection('users')
        .doc(uid)
        .set(dataToSave, SetOptions(merge: true));
  }
}