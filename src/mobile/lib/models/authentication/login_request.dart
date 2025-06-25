class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});
  Map<String, dynamic> toJson() {
    return {'Email': email, 'Password': password};
  }

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      email: json['Email'] as String,
      password: json['Password'] as String,
    );
  }

  @override
  String toString() {
    return 'LoginRequest(email: $email, password: [HIDDEN])';
  }
}
