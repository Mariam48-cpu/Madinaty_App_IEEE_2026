import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF7F2),

        appBar: AppBar(
          backgroundColor: const Color(0xFFFAF7F2),
          elevation: 0,
          centerTitle: true,

          title: const Text(
            'الإشعارات',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          iconTheme: const IconThemeData(color: Colors.black87),
        ),

        body: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.brown),
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
                        color: Colors.redAccent,
                      ),

                      const SizedBox(height: 16),

                      Text(
                        state.message,
                        textAlign: TextAlign.center,

                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 16),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown.shade800,
                          foregroundColor: Colors.white,
                        ),

                        onPressed: () {
                          context.read<NotificationCubit>().fetchNotifications(
                            widget.uid,
                          );
                        },

                        child: const Text('إعادة المحاولة'),
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
                color: Colors.brown,

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

              decoration: BoxDecoration(
                color: Colors.brown.shade50,
                shape: BoxShape.circle,
              ),

              child: Icon(
                Icons.notifications_none,
                size: 65,
                color: Colors.brown.shade400,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'لا توجد إشعارات',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              'ستظهر هنا تأكيدات الحجوزات والتحديثات والعروض.',
              textAlign: TextAlign.center,

              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
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
        alignment: Alignment.centerRight,

        padding: const EdgeInsets.symmetric(horizontal: 20),

        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),

        child: const Icon(Icons.delete_outline, color: Colors.white, size: 26),
      ),

      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('حذف الإشعار'),

              content: const Text('هل تريد حذف هذا الإشعار؟'),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('إلغاء'),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('حذف', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },

      onDismissed: (_) {
        onDelete();
      },

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(16),

        child: Container(
          padding: const EdgeInsets.all(15),

          decoration: BoxDecoration(
            color: isRead ? Colors.white : const Color(0xFFFFF8EF),

            borderRadius: BorderRadius.circular(16),

            border: Border.all(
              color: isRead ? Colors.transparent : Colors.brown.shade100,
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
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
                              fontWeight: isRead
                                  ? FontWeight.w600
                                  : FontWeight.bold,
                            ),
                          ),
                        ),

                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,

                            decoration: const BoxDecoration(
                              color: Colors.brown,
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

                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      _formatDate(createdAt),

                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
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
        return Colors.green;

      case 'booking_reminder':
        return Colors.orange;

      case 'order_update':
        return Colors.blue;

      case 'offer':
        return Colors.red;

      default:
        return Colors.brown;
    }
  }

  Color _getIconBackground() {
    switch (type) {
      case 'booking_confirmation':
        return Colors.green.shade50;

      case 'booking_reminder':
        return Colors.orange.shade50;

      case 'order_update':
        return Colors.blue.shade50;

      case 'offer':
        return Colors.red.shade50;

      default:
        return Colors.brown.shade50;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inMinutes < 1) {
      return 'منذ لحظات';
    }
    if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    }
    if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    }
    if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} يوم';
    }
    return '${date.day}/${date.month}/${date.year}';
  }
}
