import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../models/models.dart';
import '../providers/notification_provider.dart';

class NotificationSidebar extends StatefulWidget {
  final UserResponse? currentUser;
  final Animation<double>? animation;

  const NotificationSidebar({super.key, this.currentUser, this.animation});

  @override
  State<NotificationSidebar> createState() => _NotificationSidebarState();
}

class _NotificationSidebarState extends State<NotificationSidebar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final animation = widget.animation ?? const AlwaysStoppedAnimation(1.0);

    final overlayAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(
          0.3,
          1.0,
          curve: Curves.easeOut,
        ),
      ),
    );

    final sidebarAnimation =
        Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(
              0.0,
              0.7,
              curve: Curves.easeOut,
            ),
          ),
        );

    return Material(
      color: Colors.transparent,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              color: Color.fromRGBO(
                0,
                0,
                0,
                overlayAnimation.value * 0.15,
              ),
              child: Row(
                children: [
                  const Expanded(flex: 1, child: SizedBox()),
                  Expanded(
                    flex: 3,
                    child: SlideTransition(
                      position: sidebarAnimation,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          child: SafeArea(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildHeader(),
                                Expanded(child: _buildNotificationsList()),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Icon(Icons.notifications, color: AppConstants.primaryBlue, size: 24),
          const SizedBox(width: 8),
          const Text(
            AppStrings.notifications,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryBlue,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: AppConstants.primaryBlue),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    return Consumer<NotificationProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppConstants.primaryBlue),
          );
        }

        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  AppStrings.errorLoadingNotifications,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    provider.clearError();
                    if (widget.currentUser != null) {
                      provider.loadNotifications(
                        userId: widget.currentUser!.id,
                        isPolling: false,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryBlue,
                  ),
                  child: const Text(
                    'Pokušaj ponovo',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }

        if (provider.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_none,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  AppStrings.noNotifications,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: provider.notifications.length,
          itemBuilder: (context, index) {
            final notification = provider.notifications[index];
            return _buildNotificationItem(
              notification,
              provider,
              key: ValueKey(notification.id),
            );
          },
        );
      },
    );
  }

  Widget _buildNotificationItem(
    NotificationResponse notification,
    NotificationProvider provider, {
    Key? key,
  }) {
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification.isRead
            ? Colors.white
            : AppConstants.primaryBlue.withValues(alpha: 0.05),
        border: Border.all(
          color: notification.isRead
              ? Colors.grey.shade300
              : AppConstants.primaryBlue.withValues(alpha: 0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
            child: Row(
              children: [
                _buildTypeIndicatorWithReadStatus(
                  notification.type,
                  notification.isRead,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: notification.isRead
                          ? FontWeight.normal
                          : FontWeight.w600,
                      color: notification.isRead
                          ? Colors.black87
                          : AppConstants.primaryBlue,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: notification.isRead
                        ? Colors.grey.shade600
                        : AppConstants.primaryBlue,
                    size: 20,
                  ),
                  onSelected: (value) =>
                      _handleMenuAction(value, notification, provider),
                  itemBuilder: (context) => [
                    if (!notification.isRead)
                      const PopupMenuItem(
                        value: 'mark_read',
                        child: Row(
                          children: [
                            Icon(Icons.mark_email_read, size: 18),
                            SizedBox(width: 8),
                            Text(AppStrings.markAsRead),
                          ],
                        ),
                      ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete,
                            size: 18,
                            color: AppConstants.errorColor,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            AppStrings.deleteNotification,
                            style: TextStyle(color: AppConstants.errorColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              notification.message,
              style: TextStyle(
                fontSize: 14,
                color: notification.isRead
                    ? Colors.grey.shade700
                    : AppConstants.primaryBlue,
                height: 1.4,
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              _formatDate(notification.date),
              style: TextStyle(
                fontSize: 12,
                color: notification.isRead
                    ? Colors.grey.shade500
                    : AppConstants.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeIndicatorWithReadStatus(NotificationType type, bool isRead) {
    Color color;
    IconData icon;

    switch (type) {
      case NotificationType.hitno:
        color = Colors.red;
        icon = Icons.priority_high;
        break;
      case NotificationType.upozorenje:
        color = Colors.orange;
        icon = Icons.warning;
        break;
      case NotificationType.uspjesno:
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case NotificationType.greska:
        color = AppConstants.errorColor;
        icon = Icons.error;
        break;
      case NotificationType.podsjetnik:
        color = Colors.blue;
        icon = Icons.schedule;
        break;
      case NotificationType.informacija:
        color = AppConstants.primaryBlue;
        icon = Icons.info;
        break;
    }

    if (isRead) {
      color = Colors.grey.shade500;
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isRead ? Colors.grey.shade200 : color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: 16, color: color),
    );
  }

  void _handleMenuAction(
    String action,
    NotificationResponse notification,
    NotificationProvider provider,
  ) async {
    switch (action) {
      case 'mark_read':
        try {
          await provider.markAsRead(notification.id);
        } catch (e) {
          // 
        }
        break;
      case 'delete':
        try {
          await provider.deleteNotification(notification.id);
        } catch (e) {
          //
        }
        break;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Danas ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Jučer ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} dana';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }
}
