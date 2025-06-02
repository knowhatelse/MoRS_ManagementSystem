class UpdateAnnouncementRequest {
  final bool isDeleted;

  UpdateAnnouncementRequest({
    required this.isDeleted,
  });

  Map<String, dynamic> toJson() {
    return {
      'isDeleted': isDeleted,
    };
  }

  factory UpdateAnnouncementRequest.fromJson(Map<String, dynamic> json) {
    return UpdateAnnouncementRequest(
      isDeleted: json['isDeleted'] as bool,
    );
  }

  @override
  String toString() {
    return 'UpdateAnnouncementRequest(isDeleted: $isDeleted)';
  }
}
