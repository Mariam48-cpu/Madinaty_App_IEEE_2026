import 'package:dartz/dartz.dart';

import '../repositories/notification_repo_interface.dart';

class MarkAllNotificationsAsReadUseCase {
  final NotificationRepoInterface repository;

  MarkAllNotificationsAsReadUseCase(this.repository);

  Future<Either<Exception, void>> call(String uid) async {
    return await repository.markAllNotificationsAsRead(uid);
  }
}