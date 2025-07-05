class UpdateNotificationRequest {
  final int id;
  final bool isRead;

  UpdateNotificationRequest({required this.id, required this.isRead});

  Map<String, dynamic> toJson() {
    return {'id': id, 'isRead': isRead};
  }
}
