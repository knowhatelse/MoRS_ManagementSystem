class RoleResponse {
  final int id;
  final String name;

  RoleResponse({required this.id, required this.name});

  factory RoleResponse.fromJson(Map<String, dynamic> json) {
    return RoleResponse(id: json['id'] as int, name: json['name'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  @override
  String toString() {
    return 'RoleResponse(id: $id, name: $name)';
  }
}
