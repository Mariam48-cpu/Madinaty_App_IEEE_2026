import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications(String uid);

  Stream<List<NotificationModel>> watchNotifications(String uid);

  Future<void> createNotification({
    required String uid,
    required String title,
    required String body,
    required String type,
    String? bookingId,
  });

  Future<void> markNotificationAsRead({
    required String uid,
    required String notificationId,
  });

  Future<void> markAllNotificationsAsRead(String uid);

  Future<void> deleteNotification({
    required String uid,
    required String notificationId,
  });
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final FirebaseFirestore _firestore;

  NotificationRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _notificationsCollection(
      String uid,
      ) {
    return _firestore.collection('users').doc(uid).collection('notifications');
  }

  @override
  Future<List<NotificationModel>> getNotifications(String uid) async {
    final snapshot = await _notificationsCollection(
      uid,
    ).orderBy('createdAt', descending: true).get();

    return snapshot.docs.map((doc) {
      return NotificationModel.fromMap(doc.data(), doc.id);
    }).toList();
  }

  @override
  Stream<List<NotificationModel>> watchNotifications(String uid) {
    return _notificationsCollection(
      uid,
    ).orderBy('createdAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return NotificationModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  @override
  Future<void> createNotification({
    required String uid,
    required String title,
    required String body,
    required String type,
    String? bookingId,
  }) async {
    await _notificationsCollection(uid).add({
      'title': title,
      'body': body,
      'type': type,
      'bookingId': bookingId,
      'createdAt': Timestamp.now(),
      'isRead': false,
    });
  }

  @override
  Future<void> markNotificationAsRead({
    required String uid,
    required String notificationId,
  }) async {
    await _notificationsCollection(
      uid,
    ).doc(notificationId).update({'isRead': true});
  }

  @override
  Future<void> markAllNotificationsAsRead(String uid) async {
    final snapshot = await _notificationsCollection(
      uid,
    ).where('isRead', isEqualTo: false).get();

    if (snapshot.docs.isEmpty) return;

    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }

  @override
  Future<void> deleteNotification({
    required String uid,
    required String notificationId,
  }) async {
    await _notificationsCollection(uid).doc(notificationId).delete();
  }
}
