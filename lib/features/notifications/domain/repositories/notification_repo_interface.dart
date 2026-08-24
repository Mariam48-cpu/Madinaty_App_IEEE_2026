import 'package:dartz/dartz.dart';

import '../entities/notification_entity.dart';

abstract class NotificationRepoInterface {
  Future<Either<Exception, List<NotificationEntity>>> getNotifications(
    String uid,
  );

  Stream<List<NotificationEntity>> watchNotifications(String uid);

  Future<Either<Exception, void>> createNotification({
    required String uid,
    required String title,
    required String body,
    required String type,
  });

  Future<Either<Exception, void>> markNotificationAsRead({
    required String uid,
    required String notificationId,
  });

  Future<Either<Exception, void>> markAllNotificationsAsRead(
    String uid,
  );

  Future<Either<Exception, void>> deleteNotification({
    required String uid,
    required String notificationId,
  });
}
