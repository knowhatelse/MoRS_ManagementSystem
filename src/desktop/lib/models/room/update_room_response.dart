import 'room_response.dart';

class UpdateRoomResponse extends RoomResponse {
  UpdateRoomResponse({
    required super.id,
    required super.name,
    required super.type,
    required super.color,
    required super.isActive,
  });

  factory UpdateRoomResponse.fromJson(Map<String, dynamic> json) {
    return UpdateRoomResponse(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      color: json['color'],
      isActive: json['isActive'],
    );
  }
}
