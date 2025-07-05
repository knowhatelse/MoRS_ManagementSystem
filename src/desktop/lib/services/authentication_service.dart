import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import '../config/app_config.dart';
import 'api_config.dart';
import 'base_api_service.dart';

class AuthenticationService extends BaseApiService {
  static String? accessToken;

  Future<UserResponse> login(LoginRequest loginRequest) async {
    try {
      final tokenResponse = await http.post(
        Uri.parse(AppConfig.authTokenUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': AppConfig.grantType,
          'client_id': AppConfig.clientId,
          'client_secret': AppConfig.clientSecret,
          'username': loginRequest.email,
          'password': loginRequest.password,
          'scope': AppConfig.scope,
        },
      );

      if (tokenResponse.statusCode == 400 || tokenResponse.statusCode == 401) {
        String message = 'Invalid credentials';
        try {
          final errorJson = json.decode(tokenResponse.body);
          if (errorJson is Map && errorJson.containsKey('error_description')) {
            message = errorJson['error_description'];
          } else if (errorJson is Map && errorJson.containsKey('message')) {
            message = errorJson['message'];
          }
        } catch (_) {}
        throw ApiException(statusCode: 401, message: message);
      }
      if (tokenResponse.statusCode != 200) {
        throw ApiException(
          statusCode: tokenResponse.statusCode,
          message: 'Server error',
        );
      }
      final tokenJson = json.decode(tokenResponse.body);
      final accessToken = tokenJson['access_token'] as String;
      AuthenticationService.accessToken = accessToken;

      final userId = _parseUserIdFromToken(accessToken);
      final userResponse = await get(
        '${ApiConfig.users}/$userId',
        headers: ApiConfig.getAuthHeaders(accessToken),
      );
      final user = UserResponse.fromJson(userResponse);

      if (user.role == null || user.role!.id != 1) {
        throw ApiException(
          statusCode: 403,
          message: 'Access denied: Only users with role ID 1 can log in.',
        );
      }
      return user;
    } catch (e) {
      rethrow;
    }
  }

  int _parseUserIdFromToken(String token) {
    final parts = token.split('.');
    if (parts.length != 3) throw Exception('Invalid JWT');
    final payload = utf8.decode(
      base64Url.decode(base64Url.normalize(parts[1])),
    );
    final payloadMap = json.decode(payload);
    return int.parse(payloadMap['sub']);
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
