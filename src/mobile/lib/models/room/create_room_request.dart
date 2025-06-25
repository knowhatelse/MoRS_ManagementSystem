class CreateRoomRequest {
  final String name;
  final String type;
  final String color;

  CreateRoomRequest({
    required this.name,
    required this.type,
    required this.color,
  });

  factory CreateRoomRequest.fromJson(Map<String, dynamic> json) {
    return CreateRoomRequest(
      name: json['name'],
      type: json['type'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'type': type, 'color': color};
  }
}
