import '../models/models.dart';
import 'api_config.dart';
import 'base_api_service.dart';

class UserService extends BaseApiService {
  Future<List<UserResponse>> getUsers({
    String? name,
    String? surname,
    String? email,
    String? phoneNumber,
    List<int>? ids,
    bool isProfilePictureIncluded = true,
    bool isRoleIncluded = true,
  }) async {
    try {
      final queryParameters = <String, String>{};

      if (name != null && name.isNotEmpty) {
        queryParameters['name'] = name;
      }
      if (surname != null && surname.isNotEmpty) {
        queryParameters['surname'] = surname;
      }
      if (email != null && email.isNotEmpty) {
        queryParameters['email'] = email;
      }
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        queryParameters['phoneNumber'] = phoneNumber;
      }
      if (ids != null && ids.isNotEmpty) {
        queryParameters['ids'] = ids.map((id) => id.toString()).join(',');
      }

      queryParameters['isProfilePictureIncluded'] = isProfilePictureIncluded
          .toString();
      queryParameters['isRoleIncluded'] = isRoleIncluded.toString();
      final response = await get(
        ApiConfig.users,
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      );

      if (response is List) {
        return response
            .map((json) => UserResponse.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException(
          statusCode: 0,
          message: 'Invalid response format: expected list of users',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserResponse?> getUserById(int id) async {
    try {
      final response = await get('${ApiConfig.users}/$id');
      return UserResponse.fromJson(response);
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserResponse>> searchUsers(String searchTerm) async {
    try {
      if (searchTerm.isEmpty) {
        return [];
      }

      final allUsers = await getUsers();

      final lowerSearchTerm = searchTerm.toLowerCase();
      return allUsers.where((user) {
        final fullName = '${user.name} ${user.surname}'.toLowerCase();
        return fullName.contains(lowerSearchTerm) ||
            user.name.toLowerCase().contains(lowerSearchTerm) ||
            user.surname.toLowerCase().contains(lowerSearchTerm) ||
            user.email.toLowerCase().contains(lowerSearchTerm);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserResponse>> getUsersByIds(List<int> userIds) async {
    if (userIds.isEmpty) return [];
    return getUsers(ids: userIds);
  }

  Future<List<UserResponse>> getActiveUsers() async {
    final allUsers = await getUsers();
    return allUsers.where((user) => !user.isRestricted).toList();
  }

  Future<UserResponse> updateUser(int userId, UpdateUserRequest request) async {
    try {
      final response = await put(
        '${ApiConfig.users}/$userId',
        body: request.toJson(),
      );

      return UserResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updatePassword(int userId, UpdatePasswordRequest request) async {
    try {
      await put('${ApiConfig.users}/$userId/password', body: request.toJson());
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
