import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/favorite_item_entity.dart';
import '../models/favorite_item_model.dart';
import 'favorites_remote_data_source_interface.dart';

@Injectable(as: FavoritesRemoteDataSourceInterface)
class FavoritesRemoteDataSourceImpl
    implements FavoritesRemoteDataSourceInterface {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FavoritesRemoteDataSourceImpl();

  String get currentUserId => _firebaseAuth.currentUser?.uid ?? 'guest_user';

  CollectionReference<Map<String, dynamic>> _userFavoritesCollection(
    String userId,
  ) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites');
  }

  String _requireUserId() {
    return currentUserId;
  }

  @override
  Future<void> addFavorite(FavoriteItemModel item) async {
    final uid = _requireUserId();
    final docRef = _userFavoritesCollection(uid).doc(item.id);
    await docRef.set(item.toMap(), SetOptions(merge: true));
  }

  @override
  Future<void> removeFavorite(String favoriteId) async {
    final uid = _requireUserId();
    await _userFavoritesCollection(uid).doc(favoriteId).delete();
  }

  @override
  Future<void> toggleFavorite(FavoriteItemModel item) async {
    final uid = _requireUserId();
    final docRef = _userFavoritesCollection(uid).doc(item.id);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      await docRef.delete();
    } else {
      await docRef.set(item.toMap(), SetOptions(merge: true));
    }
  }

  @override
  Future<List<FavoriteItemModel>> getFavorites({
    FavoriteTargetType? type,
  }) async {
    final uid = currentUserId;
    if (uid.isEmpty) {
      return [];
    }

    Query<Map<String, dynamic>> query = _userFavoritesCollection(uid);

    if (type != null) {
      query = query.where('targetType', isEqualTo: type.value);
    }

    final snapshot = await query.get();

    final items = snapshot.docs
        .map((doc) => FavoriteItemModel.fromFirestore(doc))
        .toList();

    items.sort((a, b) {
      final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });

    return items;
  }

  @override
  Stream<List<FavoriteItemModel>> watchFavorites({
    FavoriteTargetType? type,
  }) {
    final uid = currentUserId;
    if (uid.isEmpty) {
      return Stream.value([]);
    }

    Query<Map<String, dynamic>> query = _userFavoritesCollection(uid);

    if (type != null) {
      query = query.where('targetType', isEqualTo: type.value);
    }

    return query.snapshots().map((snapshot) {
      final items = snapshot.docs
          .map((doc) => FavoriteItemModel.fromFirestore(doc))
          .toList();

      items.sort((a, b) {
        final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });

      return items;
    });
  }

  @override
  Future<bool> isFavorite({
    required String targetId,
    required FavoriteTargetType type,
  }) async {
    final uid = currentUserId;
    if (uid.isEmpty) {
      return false;
    }

    final docId = FavoriteItemEntity.generateId(type, targetId);
    final doc = await _userFavoritesCollection(uid).doc(docId).get();
    return doc.exists;
  }
}
