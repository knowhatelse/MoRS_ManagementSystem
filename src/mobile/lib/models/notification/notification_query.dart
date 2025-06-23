class NotificationQuery {
  final bool? isRead;
  final int? userId;
  final bool? isUserIncluded;

  NotificationQuery({this.isRead, this.userId, this.isUserIncluded});

  Map<String, String> toQueryParameters() {
    final Map<String, String> params = {};

    if (isRead != null) {
      params['isRead'] = isRead.toString();
    }
    if (userId != null) {
      params['userId'] = userId.toString();
    }
    if (isUserIncluded != null) {
      params['isUserIncluded'] = isUserIncluded.toString();
    }

    return params;
  }
}
