import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';

import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/widgets/skeletons/notifications_skeleton.dart';

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
      if (!mounted) return;

      final cubit = context.read<NotificationCubit>();

      cubit.markAllAsRead(widget.uid);
      cubit.watchNotifications(widget.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              if (state is NotificationInitial ||
                  state is NotificationLoading) {
                return const NotificationsSkeleton();
              }

              if (state is NotificationError) {
                return _buildErrorState(context, state);
              }

              if (state is NotificationLoaded) {
                final notifications = state.notifications;

                if (notifications.isEmpty) {
                  return _buildEmptyState(context);
                }

                final unreadCount = notifications
                    .where((notification) => !notification.isRead)
                    .length;

                return Column(
                  children: [
                    _buildHeader(context, unreadCount),

                    Expanded(
                      child: RefreshIndicator(
                        color: AppColors.primary,
                        backgroundColor: AppColors.surface,
                        onRefresh: () async {
                          await context
                              .read<NotificationCubit>()
                              .fetchNotifications(widget.uid);
                        },
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          itemCount: notifications.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final notification = notifications[index];

                            return _AnimatedNotificationItem(
                              index: index,
                              child: _NotificationItem(
                                notificationId: notification.id,
                                title: notification.title,
                                body: notification.body,
                                type: notification.type,
                                createdAt: notification.createdAt,
                                isRead: notification.isRead,
                                onTap: () {
                                  if (!notification.isRead) {
                                    context
                                        .read<NotificationCubit>()
                                        .markAsRead(
                                          uid: widget.uid,
                                          notificationId: notification.id,
                                        );
                                  }
                                },
                                onDelete: () {
                                  context
                                      .read<NotificationCubit>()
                                      .deleteNotification(
                                        uid: widget.uid,
                                        notificationId: notification.id,
                                      );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // HEADER
  // ===========================================================================

  Widget _buildHeader(BuildContext context, int unreadCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          // Back button
          Material(
            color: AppColors.surfaceVariant,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.of(context).pop(),
              child: const SizedBox(
                width: 44,
                height: 44,
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.textPrimary,
                  size: 21,
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocale.notificationsTitle.getString(context),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  unreadCount > 0
                      ? '$unreadCount ${AppLocale.notificationsTitle.getString(context)}'
                      : AppLocale.noNotificationsSubtitle.getString(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Notification icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.7),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),

                if (unreadCount > 0)
                  Positioned(
                    top: 9,
                    right: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.surfaceVariant,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // ERROR STATE
  // ===========================================================================

  Widget _buildErrorState(BuildContext context, NotificationError state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.notifications_off_outlined,
                size: 42,
                color: AppColors.error,
              ),
            ),

            const SizedBox(height: 22),

            Text(
              AppLocale.notificationsTitle.getString(context),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              state.message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 22),

            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  context.read<NotificationCubit>().fetchNotifications(
                    widget.uid,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkButton,
                  foregroundColor: AppColors.onDarkButton,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  AppLocale.retry.getString(context),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // EMPTY STATE
  // ===========================================================================

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Material(
              color: AppColors.surfaceVariant,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => Navigator.of(context).pop(),
                child: const SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.textPrimary,
                    size: 21,
                  ),
                ),
              ),
            ),
          ),
        ),

        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.75, end: 1.0),
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeOutBack,
                    builder: (context, scale, child) {
                      return Transform.scale(scale: scale, child: child);
                    },
                    child: Container(
                      width: 118,
                      height: 118,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(36),
                      ),
                      child: const Icon(
                        Icons.notifications_none_rounded,
                        size: 55,
                        color: AppColors.primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  Text(
                    AppLocale.noNotificationsTitle.getString(context),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    AppLocale.noNotificationsSubtitle.getString(context),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// NOTIFICATION ENTRY ANIMATION
// =============================================================================

class _AnimatedNotificationItem extends StatelessWidget {
  final int index;
  final Widget child;

  const _AnimatedNotificationItem({required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    final delay = Duration(milliseconds: 70 * (index > 7 ? 7 : index));

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 450 + delay.inMilliseconds),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 18 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

// =============================================================================
// NOTIFICATION CARD
// =============================================================================

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
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 25,
        ),
      ),

      confirmDismiss: (_) async {
        return await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  title: Text(
                    AppLocale.deleteNotificationTitle.getString(context),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Text(
                    AppLocale.deleteNotificationConfirm.getString(context),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: Text(
                        AppLocale.cancel.getString(context),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Text(
                        AppLocale.deleteButton.getString(context),
                        style: const TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ) ??
            false;
      },

      onDismissed: (_) {
        onDelete();
      },

      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isRead ? AppColors.surface : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isRead
                    ? AppColors.border.withValues(alpha: 0.65)
                    : AppColors.primary.withValues(alpha: 0.28),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isRead ? 0.025 : 0.045),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =================================================================
                // ICON
                // =================================================================
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getIconBackground(),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(_getIcon(), color: _getIconColor(), size: 23),
                ),

                const SizedBox(width: 12),
               Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.5,
                                height: 1.35,
                                color: AppColors.textPrimary,
                                fontWeight: isRead
                                    ? FontWeight.w600
                                    : FontWeight.w800,
                              ),
                            ),
                          ),

                          if (!isRead) ...[
                            const SizedBox(width: 7),

                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 5),

                      Text(
                        body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          height: 1.5,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 9),

                      Row(
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            size: 13,
                            color: AppColors.textMuted,
                          ),

                          const SizedBox(width: 4),

                          Text(
                            _formatDate(context, createdAt),
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (type) {
      case 'booking_confirmation':
        return Icons.check_circle_outline_rounded;

      case 'booking_reminder':
        return Icons.access_time_rounded;

      case 'order_update':
        return Icons.shopping_bag_outlined;

      case 'offer':
        return Icons.local_offer_outlined;

      default:
        return Icons.notifications_none_rounded;
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
        return AppColors.success.withValues(alpha: 0.10);

      case 'booking_reminder':
        return AppColors.warning.withValues(alpha: 0.10);

      case 'order_update':
        return AppColors.info.withValues(alpha: 0.10);

      case 'offer':
        return AppColors.error.withValues(alpha: 0.10);

      default:
        return AppColors.surfaceVariant;
    }
  }

  String _formatDate(BuildContext context, DateTime date) {
    final now = DateTime.now();

    // Prevent negative durations if the device/server time is slightly ahead.
    final difference = now.isBefore(date)
        ? Duration.zero
        : now.difference(date);

    if (difference.inMinutes < 1) {
      return AppLocale.momentsAgo.getString(context);
    }

    if (difference.inMinutes < 60) {
      return '${AppLocale.sincePrefix.getString(context)} '
          '${difference.inMinutes} '
          '${AppLocale.minutesAgoSuffix.getString(context)}';
    }

    if (difference.inHours < 24) {
      return '${AppLocale.sincePrefix.getString(context)} '
          '${difference.inHours} '
          '${AppLocale.hoursAgoSuffix.getString(context)}';
    }

    if (difference.inDays < 7) {
      return '${AppLocale.sincePrefix.getString(context)} '
          '${difference.inDays} '
          '${AppLocale.daysAgoSuffix.getString(context)}';
    }

    return '${date.day}/${date.month}/${date.year}';
  }
}
