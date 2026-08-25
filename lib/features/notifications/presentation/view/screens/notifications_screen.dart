import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';

import '../../view_model/notification_cubit.dart';

class NotificationsScreen extends StatefulWidget {
  final String uid;

  const NotificationsScreen({super.key, required this.uid});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationCubit>().markAllAsRead(widget.uid);
      context.read<NotificationCubit>().watchNotifications(widget.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocale.notificationsTitle.getString(context),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is NotificationError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkButton,
                        foregroundColor: AppColors.onDarkButton,
                      ),
                      onPressed: () {
                        context.read<NotificationCubit>().fetchNotifications(
                          widget.uid,
                        );
                      },
                      child: Text(AppLocale.retry.getString(context)),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is NotificationLoaded) {
            final notifications = state.notifications;

            if (notifications.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                await context.read<NotificationCubit>().fetchNotifications(
                  widget.uid,
                );
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final notification = notifications[index];

                  return _NotificationItem(
                    notificationId: notification.id,
                    title: notification.title,
                    body: notification.body,
                    type: notification.type,
                    createdAt: notification.createdAt,
                    isRead: notification.isRead,
                    onTap: () {
                      if (!notification.isRead) {
                        context.read<NotificationCubit>().markAsRead(
                          uid: widget.uid,
                          notificationId: notification.id,
                        );
                      }
                    },
                    onDelete: () {
                      context.read<NotificationCubit>().deleteNotification(
                        uid: widget.uid,
                        notificationId: notification.id,
                      );
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none,
                size: 65,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocale.noNotificationsTitle.getString(context),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocale.noNotificationsSubtitle.getString(context),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final String notificationId;
  final String title;
  final String body;
  final String type;
  final DateTime createdAt;
  final bool isRead;

  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NotificationItem({
    required this.notificationId,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    required this.isRead,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(notificationId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 26),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: AppColors.surface,
              title: Text(
                AppLocale.deleteNotificationTitle.getString(context),
                style: const TextStyle(color: AppColors.textPrimary),
              ),
              content: Text(
                AppLocale.deleteNotificationConfirm.getString(context),
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    AppLocale.cancel.getString(context),
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(
                    AppLocale.deleteButton.getString(context),
                    style: const TextStyle(color: AppColors.error),
                  ),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (_) => onDelete(),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: isRead ? AppColors.surface : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isRead ? AppColors.border : AppColors.primary.withValues(alpha: 0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getIconBackground(),
                  shape: BoxShape.circle,
                ),
                child: Icon(_getIcon(), color: _getIconColor(), size: 23),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.textPrimary,
                              fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
                            ),
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDate(context, createdAt),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (type) {
      case 'booking_confirmation':
        return Icons.check_circle_outline;
      case 'booking_reminder':
        return Icons.access_time;
      case 'order_update':
        return Icons.shopping_bag_outlined;
      case 'offer':
        return Icons.local_offer_outlined;
      default:
        return Icons.notifications_none;
    }
  }

  Color _getIconColor() {
    switch (type) {
      case 'booking_confirmation':
        return AppColors.success;
      case 'booking_reminder':
        return AppColors.warning;
      case 'order_update':
        return AppColors.info;
      case 'offer':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }

  Color _getIconBackground() {
    switch (type) {
      case 'booking_confirmation':
        return AppColors.success.withValues(alpha: 0.1);
      case 'booking_reminder':
        return AppColors.warning.withValues(alpha: 0.1);
      case 'order_update':
        return AppColors.info.withValues(alpha: 0.1);
      case 'offer':
        return AppColors.error.withValues(alpha: 0.1);
      default:
        return AppColors.surfaceVariant;
    }
  }

  String _formatDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inMinutes < 1) {
      return AppLocale.momentsAgo.getString(context);
    }
    if (difference.inMinutes < 60) {
      return '${AppLocale.sincePrefix.getString(context)} ${difference.inMinutes} ${AppLocale.minutesAgoSuffix.getString(context)}';
    }
    if (difference.inHours < 24) {
      return '${AppLocale.sincePrefix.getString(context)} ${difference.inHours} ${AppLocale.hoursAgoSuffix.getString(context)}';
    }
    if (difference.inDays < 7) {
      return '${AppLocale.sincePrefix.getString(context)} ${difference.inDays} ${AppLocale.daysAgoSuffix.getString(context)}';
    }
    return '${date.day}/${date.month}/${date.year}';
  }
}