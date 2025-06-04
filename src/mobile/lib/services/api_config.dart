class ApiConfig {
  // Base URL for the API
  static const String _baseUrl = 'http://192.168.0.7:5000/api';
  static String get baseUrl => _baseUrl;
  // API endpoints
  static const String authentication = '/Authentication';
  static const String announcements = '/Announcement';

  // Common headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Headers with authentication token
  static Map<String, String> getAuthHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };
}
