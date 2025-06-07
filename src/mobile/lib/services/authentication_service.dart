import '../models/models.dart';
import 'api_config.dart';
import 'base_api_service.dart';

class AuthenticationService extends BaseApiService {
  Future<UserResponse> login(LoginRequest loginRequest) async {
    try {
      final response = await post(
        ApiConfig.authentication,
        body: loginRequest.toJson(),
      );

      if (response is Map<String, dynamic>) {
        return UserResponse.fromJson(response);
      } else {
        throw ApiException(
          statusCode: 0,
          message: 'Invalid response format from login API',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      throw UnimplementedError('Logout endpoint not yet implemented in API');
    } catch (e) {
      rethrow;
    }
  }

  Future<String> refreshToken(String refreshToken) async {
    try {
      throw UnimplementedError(
        'Refresh token endpoint not yet implemented in API',
      );
    } catch (e) {
      rethrow;
    }
  }
}
