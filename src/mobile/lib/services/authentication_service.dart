import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import 'api_config.dart';
import 'base_api_service.dart';
import 'token_service.dart';
import '../constants/app_constants.dart';

class AuthenticationService extends BaseApiService {
  Future<LoginResponse> login(LoginRequest loginRequest) async {
    try {
      final tokenUrl = 'http://192.168.0.7:5000/connect/token';
      final tokenHeaders = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };
      final tokenBody = {
        'grant_type': 'password',
        'client_id': 'mors_client',
        'client_secret': 'secret',
        'username': loginRequest.email,
        'password': loginRequest.password,
        'scope': 'api openid profile',
      };
     
      final tokenResponse = await http.post(
        Uri.parse(tokenUrl),
        headers: tokenHeaders,
        body: tokenBody,
      );
   
      if (tokenResponse.statusCode == 400 || tokenResponse.statusCode == 401) {
        throw ApiException(
          statusCode: 401,
          message: AppStrings.invalidEmailOrPassword,
        );
      }
      if (tokenResponse.statusCode != 200) {
     
        throw ApiException(
          statusCode: tokenResponse.statusCode,
          message: AppStrings.serverNotResponding,
        );
      }
      final tokenJson = json.decode(tokenResponse.body);
      final accessToken = tokenJson['access_token'] as String;
    
      final userId = _parseUserIdFromToken(accessToken);
 
      final userUrl = '${ApiConfig.users}/$userId';
      final userHeaders = ApiConfig.getAuthHeaders(accessToken);
 
      final userResponse = await get(userUrl, headers: userHeaders);
   
      final user = UserResponse.fromJson(userResponse);
      if (user.role == null || (user.role!.id != 2 && user.role!.id != 3)) {
   
        throw ApiException(
          statusCode: 403,
          message: 'Access denied: Only users with role ID 2 or 3 can log in.',
        );
      }

      TokenService().setToken(accessToken);
      return LoginResponse(token: accessToken, user: user);
    } catch (e, stack) {
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
}
