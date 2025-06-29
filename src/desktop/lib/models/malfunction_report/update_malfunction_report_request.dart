class UpdateMalfunctionReportRequest {
  final bool isArchived;

  UpdateMalfunctionReportRequest({required this.isArchived});

  factory UpdateMalfunctionReportRequest.fromJson(Map<String, dynamic> json) {
    return UpdateMalfunctionReportRequest(isArchived: json['isArchived']);
  }

  Map<String, dynamic> toJson() {
    return {'isArchived': isArchived};
  }
}
