class UserQuery {
  final String? name;
  final String? surname;
  final String? email;
  final String? phoneNumber;
  final List<int>? ids;
  final bool isProfilePictureIncluded;
  final bool isRoleIncluded;

  UserQuery({
    this.name,
    this.surname,
    this.email,
    this.phoneNumber,
    this.ids,
    this.isProfilePictureIncluded = true,
    this.isRoleIncluded = true,
  });

  factory UserQuery.fromJson(Map<String, dynamic> json) {
    return UserQuery(
      name: json['name'],
      surname: json['surname'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      ids: json['ids'] != null ? List<int>.from(json['ids']) : null,
      isProfilePictureIncluded: json['isProfilePictureIncluded'] ?? true,
      isRoleIncluded: json['isRoleIncluded'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    if (name != null && name!.isNotEmpty) {
      json['name'] = name;
    }
    if (surname != null && surname!.isNotEmpty) {
      json['surname'] = surname;
    }
    if (email != null && email!.isNotEmpty) {
      json['email'] = email;
    }
    if (phoneNumber != null && phoneNumber!.isNotEmpty) {
      json['phoneNumber'] = phoneNumber;
    }
    if (ids != null && ids!.isNotEmpty) {
      json['ids'] = ids;
    }
    json['isProfilePictureIncluded'] = isProfilePictureIncluded;
    json['isRoleIncluded'] = isRoleIncluded;

    return json;
  }

  UserQuery.byIds(List<int> userIds)
    : this(ids: userIds, isProfilePictureIncluded: true, isRoleIncluded: true);

  UserQuery.byEmail(String userEmail)
    : this(
        email: userEmail,
        isProfilePictureIncluded: true,
        isRoleIncluded: true,
      );

  UserQuery.byName(String firstName, [String? lastName])
    : this(
        name: firstName,
        surname: lastName,
        isProfilePictureIncluded: true,
        isRoleIncluded: true,
      );

  UserQuery.all() : this(isProfilePictureIncluded: true, isRoleIncluded: true);
}
