import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_config.dart';

abstract class BaseApiService {
  // GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  }) async {
    try {
      Uri url = Uri.parse('${ApiConfig.baseUrl}$endpoint');

      if (queryParameters != null && queryParameters.isNotEmpty) {
        url = url.replace(queryParameters: queryParameters);
      }

      final response = await http.get(
        url,
        headers: headers ?? ApiConfig.defaultHeaders,
      );

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // POST request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');

      final response = await http.post(
        url,
        headers: headers ?? ApiConfig.defaultHeaders,
        body: body != null ? jsonEncode(body) : null,
      );

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // PUT request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');

      final response = await http.put(
        url,
        headers: headers ?? ApiConfig.defaultHeaders,
        body: body != null ? jsonEncode(body) : null,
      );

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE request
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');

      final response = await http.delete(
        url,
        headers: headers ?? ApiConfig.defaultHeaders,
      );

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Handle HTTP response
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: _getErrorMessage(response),
      );
    }
  }

  // Extract error message from response
  String _getErrorMessage(http.Response response) {
    try {
      if (response.body.isNotEmpty) {
        final errorData = jsonDecode(response.body);
        if (errorData is Map<String, dynamic>) {
          return errorData['message'] ??
              errorData['error'] ??
              'HTTP ${response.statusCode}';
        }
      }
    } catch (e) {
      // If JSON parsing fails, return status code
    }
    return 'HTTP ${response.statusCode}';
  }

  // Handle different types of errors
  Exception _handleError(dynamic error) {
    if (error is SocketException) {
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

// Custom API exception class
class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({required this.statusCode, required this.message});

  @override
  String toString() {
    return 'ApiException: $message (Status: $statusCode)';
  }
}
