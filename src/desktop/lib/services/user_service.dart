import '../models/models.dart';
import 'api_config.dart';
import 'base_api_service.dart';

class UserService extends BaseApiService {
  Future<List<UserResponse>> getUsers([UserQuery? query]) async {
    try {
      final queryParameters = query?.toQueryParameters() ?? <String, String>{};

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

  Future<UserResponse> createUser(CreateUserRequest request) async {
    try {
      await post('/account/register', body: request.toJson());

      final users = await get(ApiConfig.users);

      final userList = (users as List)
          .map((u) => UserResponse.fromJson(u))
          .toList();
      final user = userList.firstWhere((u) => u.email == request.email);

      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserResponse?> updateUser(
    int userId,
    UpdateUserRequest request,
  ) async {
    try {
      final response = await put(
        '${ApiConfig.users}/$userId',
        body: request.toJson(),
      );

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

  Future<bool> deleteUser(int id) async {
    try {
      await delete('${ApiConfig.users}/$id');
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

  Future<bool> updatePassword(int userId, UpdatePasswordRequest request) async {
    try {
      await put('${ApiConfig.users}/$userId/password', body: request.toJson());
      return true;
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
    final query = UserQuery.byIds(userIds);
    return getUsers(query);
  }

  Future<List<UserResponse>> getActiveUsers() async {
    final allUsers = await getUsers();
    return allUsers.where((user) => !user.isRestricted).toList();
  }
}
