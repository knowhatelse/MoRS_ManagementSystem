import '../models/models.dart';
import '../constants/app_constants.dart';
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
        final userResponse = UserResponse.fromJson(response);

        if (userResponse.role?.id != 1) {
          throw ApiException(statusCode: 403, message: AppStrings.accessDenied);
        }

        if (userResponse.role == null) {
          throw ApiException(
            statusCode: 403,
            message: AppStrings.noRoleAssigned,
          );
        }

        return userResponse;
      } else {
        throw ApiException(statusCode: 0, message: AppStrings.invalidResponse);
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
