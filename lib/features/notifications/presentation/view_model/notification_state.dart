part of 'notification_cubit.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> notifications;
  final int unreadCount;

  NotificationLoaded(
    this.notifications,
    this.unreadCount,
  );
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}