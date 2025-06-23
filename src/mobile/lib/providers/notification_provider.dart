import 'dart:async';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();

  List<NotificationResponse> _notifications = [];
  bool _isLoading = false;
  String? _error;
  Timer? _pollingTimer;
  int? _currentUserId;

  List<NotificationResponse> get notifications => _notifications;

  bool get isLoading => _isLoading;
  String? get error => _error;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
  bool get hasUnreadNotifications => unreadCount > 0;

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void startPolling({
    required int userId,
    Duration interval = const Duration(seconds: 30),
  }) {
    _currentUserId = userId;
    _pollingTimer?.cancel();

    loadNotifications(userId: userId, isPolling: false);

    _pollingTimer = Timer.periodic(interval, (timer) {
      if (_currentUserId != null) {
        loadNotifications(userId: _currentUserId!, isPolling: true);
      }
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _currentUserId = null;
  }

  Future<void> loadNotifications({int? userId, bool isPolling = false}) async {
    if (!isPolling) {
      _isLoading = true;
      _error = null;
      notifyListeners();
    }

    try {
      final query = NotificationQuery(userId: userId, isUserIncluded: true);
      final notifications = await _notificationService.getNotifications(
        query: query,
      );
      notifications.sort((a, b) => b.date.compareTo(a.date));
      _notifications = notifications;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      if (!isPolling) {
        _isLoading = false;
      }
      notifyListeners();
    }
  }

  Future<void> markAsRead(int notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index == -1) {
      throw Exception('Notification with ID $notificationId not found');
    }

    final originalNotification = _notifications[index];

    try {
      _notifications[index] = originalNotification.copyWith(isRead: true);
      notifyListeners();

      final request = UpdateNotificationRequest(
        id: notificationId,
        isRead: true,
      );

      await _notificationService.updateNotification(request);
    } catch (e) {
      _notifications[index] = originalNotification;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteNotification(int notificationId) async {
    try {
      await _notificationService.deleteNotification(notificationId);

      _notifications.removeWhere((n) => n.id == notificationId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
