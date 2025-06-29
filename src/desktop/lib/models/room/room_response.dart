class RoomResponse {
  final int id;
  final String name;
  final String type;
  final String color;
  final bool isActive;

  RoomResponse({
    required this.id,
    required this.name,
    required this.type,
    required this.color,
    required this.isActive,
  });

  factory RoomResponse.fromJson(Map<String, dynamic> json) {
    return RoomResponse(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      color: json['color'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'color': color,
      'isActive': isActive,
    };
  }
}
