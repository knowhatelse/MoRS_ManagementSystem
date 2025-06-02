class CreateAnnouncementRequest {
  final String title;
  final String content;
  final int userId;

  CreateAnnouncementRequest({
    required this.title,
    required this.content,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {'title': title, 'content': content, 'userId': userId};
  }

  factory CreateAnnouncementRequest.fromJson(Map<String, dynamic> json) {
    return CreateAnnouncementRequest(
      title: json['title'] as String,
      content: json['content'] as String,
      userId: json['userId'] as int,
    );
  }

  // Validation methods following C# validation attributes
  bool isValidTitle() {
    return title.length >= 5 && title.length <= 100;
  }

  bool isValidContent() {
    return content.length >= 10 && content.length <= 2000;
  }

  bool isValidUserId() {
    return userId >= 1;
  }

  bool isValid() {
    return isValidTitle() && isValidContent() && isValidUserId();
  }

  @override
  String toString() {
    return 'CreateAnnouncementRequest(title: $title, content: ${content.substring(0, content.length > 50 ? 50 : content.length)}..., userId: $userId)';
  }
}
