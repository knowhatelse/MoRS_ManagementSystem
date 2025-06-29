class UpdateAnnouncementRequest {
  final String title;
  final String content;
  final bool? isDeleted;

  UpdateAnnouncementRequest({
    required this.title,
    required this.content,
    this.isDeleted,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'title': title, 'content': content};

    if (isDeleted != null) {
      json['isDeleted'] = isDeleted;
    }

    return json;
  }

  factory UpdateAnnouncementRequest.fromJson(Map<String, dynamic> json) {
    return UpdateAnnouncementRequest(
      title: json['title'] as String,
      content: json['content'] as String,
      isDeleted: json['isDeleted'] as bool?,
    );
  }

  @override
  String toString() {
    return 'UpdateAnnouncementRequest(title: $title, content: $content, isDeleted: $isDeleted)';
  }
}
