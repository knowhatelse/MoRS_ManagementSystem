class CreateProfilePictureRequest {
  final int userId;
  final String base64Data;

  CreateProfilePictureRequest({required this.userId, required this.base64Data});

  factory CreateProfilePictureRequest.fromJson(Map<String, dynamic> json) {
    return CreateProfilePictureRequest(
      userId: json['userId'] as int,
      base64Data: json['base64Data'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'base64Data': base64Data};
  }

  @override
  String toString() {
    return 'CreateProfilePictureRequest(userId: $userId, base64Data: [${base64Data.length} chars])';
  }
}
