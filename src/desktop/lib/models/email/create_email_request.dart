class CreateEmailRequest {
  final String subject;
  final String body;
  final List<int> userIds;

  CreateEmailRequest({
    required this.subject,
    required this.body,
    required this.userIds,
  });

  factory CreateEmailRequest.fromJson(Map<String, dynamic> json) {
    return CreateEmailRequest(
      subject: json['subject'] as String,
      body: json['body'] as String,
      userIds: List<int>.from(json['userIds'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {'subject': subject, 'body': body, 'userIds': userIds};
  }

  bool get isValid {
    return subject.length >= 5 &&
        subject.length <= 100 &&
        body.length >= 10 &&
        body.length <= 2000 &&
        userIds.isNotEmpty;
  }
}
