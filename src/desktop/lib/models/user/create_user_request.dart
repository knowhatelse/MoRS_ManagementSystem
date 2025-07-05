class CreateUserRequest {
  final String name;
  final String surname;
  final String email;
  final String phoneNumber;
  final int roleId;

  CreateUserRequest({
    required this.name,
    required this.surname,
    required this.email,
    required this.phoneNumber,
    required this.roleId,
  });

  factory CreateUserRequest.fromJson(Map<String, dynamic> json) {
    return CreateUserRequest(
      name: json['name'],
      surname: json['surname'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      roleId: json['roleId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surname': surname,
      'email': email,
      'phoneNumber': phoneNumber,
      'roleId': roleId,
    };
  }
}
