import 'package:dartz/dartz.dart';

import '../repositories/notification_repo_interface.dart';

class DeleteNotificationUseCase {
  final NotificationRepoInterface repository;

  DeleteNotificationUseCase(this.repository);

  Future<Either<Exception, void>> call({
    required String uid,
    required String notificationId,
  }) async {
    return await repository.deleteNotification(
      uid: uid,
      notificationId: notificationId,
    );
  }
}