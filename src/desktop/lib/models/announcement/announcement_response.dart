import '../user/user_response.dart';

class AnnouncementResponse {
  final int id;
  final String title;
  final String content;
  final DateTime createdAt;
  final UserResponse? user;

  AnnouncementResponse({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.user,
  });

  factory AnnouncementResponse.fromJson(Map<String, dynamic> json) {
    return AnnouncementResponse(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      user: json['user'] != null
          ? UserResponse.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'user': user?.toJson(),
    };
  }

  @override
  String toString() {
    return 'AnnouncementResponse(id: $id, title: $title, createdAt: $createdAt, user: ${user?.fullName ?? 'Unknown'})';
  }
}
