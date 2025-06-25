class MalfunctionReportQuery {
  final int? roomId;
  final int? userId;
  final DateTime? date;
  final bool? isArchived;
  final bool isRoomIncluded;
  final bool isUserIncluded;

  MalfunctionReportQuery({
    this.roomId,
    this.userId,
    this.date,
    this.isArchived,
    this.isRoomIncluded = true,
    this.isUserIncluded = true,
  });

  factory MalfunctionReportQuery.fromJson(Map<String, dynamic> json) {
    return MalfunctionReportQuery(
      roomId: json['roomId'],
      userId: json['userId'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      isArchived: json['isArchived'],
      isRoomIncluded: json['isRoomIncluded'] ?? true,
      isUserIncluded: json['isUserIncluded'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    if (roomId != null) {
      json['roomId'] = roomId;
    }
    if (userId != null) {
      json['userId'] = userId;
    }
    if (date != null) {
      json['date'] = date!.toIso8601String().split('T')[0];
    }
    if (isArchived != null) {
      json['isArchived'] = isArchived;
    }
    json['isRoomIncluded'] = isRoomIncluded;
    json['isUserIncluded'] = isUserIncluded;

    return json;
  }

  Map<String, String> toQueryParameters() {
    final params = <String, String>{};

    if (roomId != null) {
      params['roomId'] = roomId.toString();
    }
    if (userId != null) {
      params['userId'] = userId.toString();
    }
    if (date != null) {
      params['date'] = date!.toIso8601String().split('T')[0];
    }
    if (isArchived != null) {
      params['isArchived'] = isArchived.toString();
    }
    params['isRoomIncluded'] = isRoomIncluded.toString();
    params['isUserIncluded'] = isUserIncluded.toString();

    return params;
  }

  factory MalfunctionReportQuery.forRoom(int roomId) {
    return MalfunctionReportQuery(
      roomId: roomId,
      isRoomIncluded: true,
      isUserIncluded: true,
    );
  }

  factory MalfunctionReportQuery.forUser(int userId) {
    return MalfunctionReportQuery(
      userId: userId,
      isRoomIncluded: true,
      isUserIncluded: true,
    );
  }

  factory MalfunctionReportQuery.forDate(DateTime date) {
    return MalfunctionReportQuery(
      date: date,
      isRoomIncluded: true,
      isUserIncluded: true,
    );
  }

  factory MalfunctionReportQuery.activeOnly() {
    return MalfunctionReportQuery(
      isArchived: false,
      isRoomIncluded: true,
      isUserIncluded: true,
    );
  }

  factory MalfunctionReportQuery.archivedOnly() {
    return MalfunctionReportQuery(
      isArchived: true,
      isRoomIncluded: true,
      isUserIncluded: true,
    );
  }

  factory MalfunctionReportQuery.byRoom(int roomId) {
    return MalfunctionReportQuery(
      roomId: roomId,
      isRoomIncluded: true,
      isUserIncluded: true,
    );
  }
}
