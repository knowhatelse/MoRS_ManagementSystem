class UpdatePasswordRequest {
  final String newPassword;

  UpdatePasswordRequest({required this.newPassword});

  Map<String, dynamic> toJson() {
    return {'newPassword': newPassword};
  }

  factory UpdatePasswordRequest.fromJson(Map<String, dynamic> json) {
    return UpdatePasswordRequest(newPassword: json['newPassword']);
  }
}
