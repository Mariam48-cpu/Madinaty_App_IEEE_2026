import 'package:dartz/dartz.dart';

import '../repositories/notification_repo_interface.dart';

class CreateNotificationUseCase {
  final NotificationRepoInterface repository;

  CreateNotificationUseCase(this.repository);

  Future<Either<Exception, void>> call({
    required String uid,
    required String title,
    required String body,
    required String type,
    String? bookingId,
  }) async {
    return await repository.createNotification(
      uid: uid,
      title: title,
      body: body,
      type: type,
      bookingId: bookingId,
    );
  }
}