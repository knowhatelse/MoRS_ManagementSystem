import '../models/models.dart';
import 'api_config.dart';
import 'base_api_service.dart';

class RoomService extends BaseApiService {
  Future<List<RoomResponse>> getRooms([RoomQuery? query]) async {
    try {
      final queryParameters = query?.toQueryParameters() ?? <String, String>{};

      final response = await get(
        ApiConfig.rooms,
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      );

      if (response is List) {
        final rooms = response
            .map((json) => RoomResponse.fromJson(json as Map<String, dynamic>))
            .toList();
        return rooms;
      } else {
        throw ApiException(
          statusCode: 0,
          message: 'Invalid response format: expected list of rooms',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<RoomResponse>> getActiveRooms() async {
    return getRooms(RoomQuery.activeOnly());
  }

  Future<List<RoomResponse>> getAllRooms() async {
    return getRooms(RoomQuery.all());
  }

  Future<RoomResponse?> getRoomById(int id) async {
    try {
      final response = await get('${ApiConfig.rooms}/$id');
      return RoomResponse.fromJson(response);
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<RoomResponse> createRoom(CreateRoomRequest request) async {
    try {
      if (!_isValidCreateRequest(request)) {
        throw ApiException(
          statusCode: 400,
          message: 'Invalid room request: check name, type, and color format',
        );
      }

      final response = await post(ApiConfig.rooms, body: request.toJson());

      return RoomResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<RoomResponse?> updateRoom(int id, CreateRoomRequest request) async {
    try {
      if (!_isValidCreateRequest(request)) {
        throw ApiException(
          statusCode: 400,
          message: 'Invalid room request: check name, type, and color format',
        );
      }

      final response = await put(
        '${ApiConfig.rooms}/$id',
        body: request.toJson(),
      );
      return RoomResponse.fromJson(response);
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteRoom(int id) async {
    try {
      await delete('${ApiConfig.rooms}/$id');
      return true;
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        return false;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<RoomResponse>> getInactiveRooms() async {
    return getRooms(RoomQuery.inactiveOnly());
  }

  bool _isValidCreateRequest(CreateRoomRequest request) {
    if (request.name.length < 2 || request.name.length > 50) {
      return false;
    }

    if (request.type.length < 2 || request.type.length > 50) {
      return false;
    }

    final colorRegex = RegExp(r'^#(?:[0-9a-fA-F]{3}){1,2}$');
    if (!colorRegex.hasMatch(request.color)) {
      return false;
    }

    return true;
  }
}
