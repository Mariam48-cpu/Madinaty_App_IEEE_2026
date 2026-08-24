import 'package:dartz/dartz.dart';

import '../repositories/notification_repo_interface.dart';

class MarkNotificationReadUseCase {
  final NotificationRepoInterface repository;

  MarkNotificationReadUseCase(this.repository);

  Future<Either<Exception, void>> call({
    required String uid,
    required String notificationId,
  }) async {
    return await repository.markNotificationAsRead(
      uid: uid,
      notificationId: notificationId,
    );
  }
}