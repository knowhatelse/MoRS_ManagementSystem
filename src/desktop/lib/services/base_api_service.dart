import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'authentication_service.dart';

abstract class BaseApiService {
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  }) async {
    try {
      Uri url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      if (queryParameters != null && queryParameters.isNotEmpty) {
        url = url.replace(queryParameters: queryParameters);
      }
      final authHeaders = headers ?? _getAuthHeadersWithToken();

      final response = await http
          .get(url, headers: authHeaders)
          .timeout(ApiConfig.requestTimeout);
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final authHeaders = headers ?? _getAuthHeadersWithToken();
      final requestBody = body != null ? jsonEncode(body) : null;
      final response = await http
          .post(url, headers: authHeaders, body: requestBody)
          .timeout(ApiConfig.requestTimeout);
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final authHeaders = headers ?? _getAuthHeadersWithToken();

      final response = await http
          .put(
            url,
            headers: authHeaders,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.requestTimeout);
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final authHeaders = headers ?? _getAuthHeadersWithToken();

      final response = await http
          .delete(url, headers: authHeaders)
          .timeout(ApiConfig.requestTimeout);
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Map<String, String> _getAuthHeadersWithToken() {
    final token = AuthenticationService.accessToken;
    if (token != null && token.isNotEmpty) {
      return ApiConfig.getAuthHeaders(token);
    }
    return ApiConfig.defaultHeaders;
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      try {
        final decoded = jsonDecode(response.body);
        return decoded;
      } catch (e) {
        throw ApiException(
          statusCode: response.statusCode,
          message: 'Invalid JSON response: ${e.toString()}',
        );
      }
    } else {
      final errorMessage = _getErrorMessage(response);
      throw ApiException(
        statusCode: response.statusCode,
        message: errorMessage,
      );
    }
  }

  String _getErrorMessage(http.Response response) {
    try {
      if (response.body.isNotEmpty) {
        final errorData = jsonDecode(response.body);

        if (errorData is Map<String, dynamic>) {
          if (errorData.containsKey('detail')) {
            return errorData['detail'] ?? 'HTTP ${response.statusCode}';
          }
          if (errorData.containsKey('errors')) {
            final errors = errorData['errors'];
            if (errors is Map<String, dynamic>) {
              final allErrors = <String>[];
              errors.forEach((key, value) {
                if (value is List) {
                  allErrors.addAll(value.cast<String>());
                } else {
                  allErrors.add(value.toString());
                }
              });
              if (allErrors.isNotEmpty) {
                return allErrors.join(', ');
              }
            }
          }
          return errorData['message'] ??
              errorData['error'] ??
              errorData['Message'] ??
              errorData['title'] ??
              'HTTP ${response.statusCode}';
        }
      }
    } catch (e) {
      // 
    }
    return 'HTTP ${response.statusCode}';
  }

  Exception _handleError(dynamic error) {
    if (error is TimeoutException) {
      return ApiException(
        statusCode: 0,
        message: 'Connection timeout - server is not responding',
      );
    } else if (error is SocketException) {
      return ApiException(
        statusCode: 0,
        message: 'No internet connection or server unreachable',
      );
    } else if (error is HttpException) {
      return ApiException(
        statusCode: 0,
        message: 'HTTP error: ${error.message}',
      );
    } else if (error is FormatException) {
      return ApiException(statusCode: 0, message: 'Invalid response format');
    } else if (error is ApiException) {
      return error;
    } else {
      return ApiException(
        statusCode: 0,
        message: 'Unexpected error: ${error.toString()}',
      );
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({required this.statusCode, required this.message});

  @override
  String toString() {
    return 'ApiException: $message (Status: $statusCode)';
  }
}
