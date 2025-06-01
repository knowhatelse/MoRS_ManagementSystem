import '../user/user_response.dart';

class LoginResponse {
  final String token;
  final String? refreshToken;
  final UserResponse user;
  final DateTime? expiresAt;

  LoginResponse({
    required this.token,
    this.refreshToken,
    required this.user,
    this.expiresAt,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String?,
      user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
      'user': user.toJson(),
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  @override
  String toString() {
    return 'LoginResponse(token: [HIDDEN], user: ${user.toString()})';
  }
}
