class MalfunctionReportResponse {
  final int id;
  final String description;
  final DateTime date;
  final Map<String, dynamic>? room;
  final Map<String, dynamic>? reportedByUser;
  final bool isArchived;

  MalfunctionReportResponse({
    required this.id,
    required this.description,
    required this.date,
    this.room,
    this.reportedByUser,
    required this.isArchived,
  });

  int? get roomId => room?['id'];
  String get roomName => room?['name'] ?? '';
  String get roomColor => room?['color'] ?? '#FFFFFF';
  int? get reportedByUserId => reportedByUser?['id'];
  String get reportedByUserName => reportedByUser?['name'] ?? '';

  factory MalfunctionReportResponse.fromJson(Map<String, dynamic> json) {
    return MalfunctionReportResponse(
      id: json['id'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      room: json['room'] as Map<String, dynamic>?,
      reportedByUser: json['reportedByUser'] as Map<String, dynamic>?,
      isArchived: json['isArchived'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'date': date.toIso8601String(),
      'room': room,
      'reportedByUser': reportedByUser,
      'isArchived': isArchived,
    };
  }
}
