class UpdateRoomRequest {
  final String name;
  final String type;
  final String color;
  final bool isActive;

  UpdateRoomRequest({
    required this.name,
    required this.type,
    required this.color,
    required this.isActive,
  });

  factory UpdateRoomRequest.fromJson(Map<String, dynamic> json) {
    return UpdateRoomRequest(
      name: json['name'],
      type: json['type'],
      color: json['color'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'type': type, 'color': color, 'isActive': isActive};
  }
}
