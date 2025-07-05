class UpdateUserRequest {
  final String name;
  final String surname;
  final String email;
  final String phoneNumber;
  final bool isRestricted;
  final int roleId;

  UpdateUserRequest({
    required this.name,
    required this.surname,
    required this.email,
    required this.phoneNumber,
    required this.isRestricted,
    required this.roleId,
  });

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) {
    return UpdateUserRequest(
      name: json['name'] as String,
      surname: json['surname'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      isRestricted: json['isRestricted'] as bool,
      roleId: json['roleId'] as int,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surname': surname,
      'email': email,
      'phoneNumber': phoneNumber,
      'isRestricted': isRestricted,
      'roleId': roleId,
    };
  }

  @override
  String toString() {
    return 'UpdateUserRequest(name: $name, surname: $surname, email: $email, phoneNumber: $phoneNumber, isRestricted: $isRestricted, roleId: $roleId)';
  }
}
