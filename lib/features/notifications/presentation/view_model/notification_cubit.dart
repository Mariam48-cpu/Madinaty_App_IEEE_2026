import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repo_interface.dart';
import '../../domain/use_cases/delete_notification_use_case.dart';
import '../../domain/use_cases/get_notifications_use_case.dart';
import '../../domain/use_cases/mark_all_notifications_as_read_use_case.dart';
import '../../domain/use_cases/mark_notification_read_use_case.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationReadUseCase markNotificationReadUseCase;
  final MarkAllNotificationsAsReadUseCase markAllNotificationsAsReadUseCase;
  final DeleteNotificationUseCase deleteNotificationUseCase;

  final NotificationRepoInterface notificationRepository;

  StreamSubscription<List<NotificationEntity>>? _notificationsSubscription;

  NotificationCubit({
    required this.getNotificationsUseCase,
    required this.markNotificationReadUseCase,
    required this.markAllNotificationsAsReadUseCase,
    required this.deleteNotificationUseCase,
    required this.notificationRepository,
  }) : super(NotificationInitial());

  Future<void> fetchNotifications(String uid) async {
    emit(NotificationLoading());

    final result = await getNotificationsUseCase(uid);

    result.fold(
      (failure) {
        emit(NotificationError(failure.toString()));
      },
      (notifications) {
        emit(NotificationLoaded(notifications, _getUnreadCount(notifications)));
      },
    );
  }

  void watchNotifications(String uid) {
    _notificationsSubscription?.cancel();

    _notificationsSubscription = notificationRepository
        .watchNotifications(uid)
        .listen(
          (notifications) {
            emit(
              NotificationLoaded(notifications, _getUnreadCount(notifications)),
            );
          },
          onError: (error) {
            emit(NotificationError(error.toString()));
          },
        );
  }

  Future<void> markAsRead({
    required String uid,
    required String notificationId,
  }) async {
    final result = await markNotificationReadUseCase(
      uid: uid,
      notificationId: notificationId,
    );

    result.fold((failure) {
      emit(NotificationError(failure.toString()));
    }, (_) {});
  }

  Future<void> markAllAsRead(String uid) async {
    final result = await markAllNotificationsAsReadUseCase(uid);

    result.fold((failure) {
      emit(NotificationError(failure.toString()));
    }, (_) {});
  }

  Future<void> deleteNotification({
    required String uid,
    required String notificationId,
  }) async {
    final result = await deleteNotificationUseCase(
      uid: uid,
      notificationId: notificationId,
    );

    result.fold((failure) {
      emit(NotificationError(failure.toString()));
    }, (_) {});
  }

  int _getUnreadCount(List<NotificationEntity> notifications) {
    return notifications.where((notification) => !notification.isRead).length;
  }

  @override
  Future<void> close() {
    _notificationsSubscription?.cancel();
    return super.close();
  }
}
