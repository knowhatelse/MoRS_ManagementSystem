import '../models/models.dart';
import 'api_config.dart';
import 'base_api_service.dart';

class AuthenticationService extends BaseApiService {
  // Login method
  Future<UserResponse> login(LoginRequest loginRequest) async {
    try {
      final response = await post(
        ApiConfig.authentication,
        body: loginRequest.toJson(),
      );

      // Since the API returns UserResponse directly (not wrapped in LoginResponse),
      // we create the UserResponse from the API response
      if (response is Map<String, dynamic>) {
        return UserResponse.fromJson(response);
      } else {
        throw ApiException(
          statusCode: 0,
          message: 'Invalid response format from login API',
        );
      }
    } catch (e) {
      // Re-throw the error to be handled by the UI
      rethrow;
    }
  }

  // Future method for logout (when implemented in API)
  Future<void> logout() async {
    try {
      // This would be implemented when the API has a logout endpoint
      // await post('/Authentication/logout');
      throw UnimplementedError('Logout endpoint not yet implemented in API');
    } catch (e) {
      rethrow;
    }
  }

  // Future method for token refresh (when implemented in API)
  Future<String> refreshToken(String refreshToken) async {
    try {
      // This would be implemented when the API has a refresh token endpoint
      // final response = await post('/Authentication/refresh', body: {'refreshToken': refreshToken});
      // return response['token'];
      throw UnimplementedError(
        'Refresh token endpoint not yet implemented in API',
      );
    } catch (e) {
      rethrow;
    }
  }
}
