import 'package:dartz/dartz.dart';

import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repo_interface.dart';
import '../data_sources/notification_remote_data_source.dart';

class NotificationRepoImp implements NotificationRepoInterface {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepoImp({required this.remoteDataSource});

  @override
  Future<Either<Exception, List<NotificationEntity>>> getNotifications(
    String uid,
  ) async {
    try {
      final notifications = await remoteDataSource.getNotifications(uid);

      return Right(notifications);
    } catch (e) {
      return Left(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Stream<List<NotificationEntity>> watchNotifications(String uid) {
    return remoteDataSource.watchNotifications(uid);
  }

  @override
  Future<Either<Exception, void>> createNotification({
    required String uid,
    required String title,
    required String body,
    required String type,
  }) async {
    try {
      await remoteDataSource.createNotification(
        uid: uid,
        title: title,
        body: body,
        type: type,
      );

      return const Right(null);
    } catch (e) {
      return Left(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, void>> markNotificationAsRead({
    required String uid,
    required String notificationId,
  }) async {
    try {
      await remoteDataSource.markNotificationAsRead(
        uid: uid,
        notificationId: notificationId,
      );

      return const Right(null);
    } catch (e) {
      return Left(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, void>> markAllNotificationsAsRead(String uid) async {
    try {
      await remoteDataSource.markAllNotificationsAsRead(uid);

      return const Right(null);
    } catch (e) {
      return Left(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, void>> deleteNotification({
    required String uid,
    required String notificationId,
  }) async {
    try {
      await remoteDataSource.deleteNotification(
        uid: uid,
        notificationId: notificationId,
      );

      return const Right(null);
    } catch (e) {
      return Left(e is Exception ? e : Exception(e.toString()));
    }
  }
}
