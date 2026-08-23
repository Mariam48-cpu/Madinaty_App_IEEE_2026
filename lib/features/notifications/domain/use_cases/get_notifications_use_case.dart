import 'package:dartz/dartz.dart';

import '../entities/notification_entity.dart';
import '../repositories/notification_repo_interface.dart';

class GetNotificationsUseCase {
  final NotificationRepoInterface repository;

  GetNotificationsUseCase(this.repository);

  Future<Either<Exception, List<NotificationEntity>>> call(
    String uid,
  ) async {
    return await repository.getNotifications(uid);
  }
}