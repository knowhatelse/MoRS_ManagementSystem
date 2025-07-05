class CreateMalfunctionReportRequest {
  final String description;
  final int roomId;
  final int reportedByUserId;

  CreateMalfunctionReportRequest({
    required this.description,
    required this.roomId,
    required this.reportedByUserId,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'roomId': roomId,
      'reportedByUserId': reportedByUserId,
    };
  }
}
