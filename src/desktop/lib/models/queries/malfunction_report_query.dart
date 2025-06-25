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

  MalfunctionReportQuery.forRoom(int roomId)
    : this(roomId: roomId, isRoomIncluded: true, isUserIncluded: true);

  MalfunctionReportQuery.forUser(int userId)
    : this(userId: userId, isRoomIncluded: true, isUserIncluded: true);

  MalfunctionReportQuery.forDate(DateTime date)
    : this(date: date, isRoomIncluded: true, isUserIncluded: true);

  MalfunctionReportQuery.activeOnly()
    : this(isArchived: false, isRoomIncluded: true, isUserIncluded: true);

  MalfunctionReportQuery.archivedOnly()
    : this(isArchived: true, isRoomIncluded: true, isUserIncluded: true);
}
