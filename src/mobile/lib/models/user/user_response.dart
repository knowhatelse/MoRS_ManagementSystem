import '../profile_picture/profile_picture_response.dart';
import '../role/role_response.dart';

class UserResponse {
  final int id;
  final String name;
  final String surname;
  final String email;
  final String phoneNumber;
  final bool isRestricted;
  final ProfilePictureResponse? profilePicture;
  final RoleResponse? role;

  UserResponse({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.phoneNumber,
    required this.isRestricted,
    this.profilePicture,
    this.role,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] as int,
      name: json['name'] as String,
      surname: json['surname'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      isRestricted: json['isRestricted'] as bool,
      profilePicture: json['profilePicture'] != null
          ? ProfilePictureResponse.fromJson(
              json['profilePicture'] as Map<String, dynamic>,
            )
          : null,
      role: json['role'] != null
          ? RoleResponse.fromJson(json['role'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'email': email,
      'phoneNumber': phoneNumber,
      'isRestricted': isRestricted,
      'profilePicture': profilePicture?.toJson(),
      'role': role?.toJson(),
    };
  }

  String get fullName => '$name $surname';

  @override
  String toString() {
    return 'UserResponse(id: $id, name: $name, surname: $surname, email: $email, isRestricted: $isRestricted)';
  }
}
