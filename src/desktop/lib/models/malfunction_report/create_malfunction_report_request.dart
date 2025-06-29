class CreateMalfunctionReportRequest {
  final String description;
  final int roomId;
  final int reportedByUserId;

  CreateMalfunctionReportRequest({
    required this.description,
    required this.roomId,
    required this.reportedByUserId,
  });

  factory CreateMalfunctionReportRequest.fromJson(Map<String, dynamic> json) {
    return CreateMalfunctionReportRequest(
      description: json['description'],
      roomId: json['roomId'],
      reportedByUserId: json['reportedByUserId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'roomId': roomId,
      'reportedByUserId': reportedByUserId,
    };
  }
}
