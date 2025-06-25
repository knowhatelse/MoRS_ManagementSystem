import 'room_response.dart';

class CreateRoomResponse extends RoomResponse {
  CreateRoomResponse({
    required super.id,
    required super.name,
    required super.type,
    required super.color,
    required super.isActive,
  });

  factory CreateRoomResponse.fromJson(Map<String, dynamic> json) {
    return CreateRoomResponse(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      color: json['color'],
      isActive: json['isActive'],
    );
  }
}
