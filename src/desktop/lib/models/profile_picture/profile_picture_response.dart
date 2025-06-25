class ProfilePictureResponse {
  final int id;
  final String base64Data;
  final String fileName;
  final String fileType;

  ProfilePictureResponse({
    required this.id,
    required this.base64Data,
    required this.fileName,
    required this.fileType,
  });

  factory ProfilePictureResponse.fromJson(Map<String, dynamic> json) {
    return ProfilePictureResponse(
      id: json['id'] as int,
      base64Data: json['base64Data'] as String,
      fileName: json['fileName'] as String,
      fileType: json['fileType'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'base64Data': base64Data,
      'fileName': fileName,
      'fileType': fileType,
    };
  }

  @override
  String toString() {
    return 'ProfilePictureResponse(id: $id, fileName: $fileName, fileType: $fileType)';
  }
}
