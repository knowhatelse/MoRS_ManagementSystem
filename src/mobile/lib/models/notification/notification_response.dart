import '../models.dart';

class NotificationResponse {
  final int id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime date;
  final bool isRead;
  final UserResponse? user;

  NotificationResponse({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.date,
    required this.isRead,
    this.user,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      type: NotificationType.fromString(json['type'].toString()),
      date: DateTime.parse(json['date']),
      isRead: json['isRead'] ?? false,
      user: json['user'] != null
          ? UserResponse.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.toJson(),
      'date': date.toIso8601String(),
      'isRead': isRead,
      'user': user?.toJson(),
    };
  }

  NotificationResponse copyWith({
    int? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? date,
    bool? isRead,
    UserResponse? user,
  }) {
    return NotificationResponse(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      date: date ?? this.date,
      isRead: isRead ?? this.isRead,
      user: user ?? this.user,
    );
  }
}
