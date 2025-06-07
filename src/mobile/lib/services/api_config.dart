class ApiConfig {
  static const String _baseUrl = 'http://192.168.0.7:5000/api';
  static String get baseUrl => _baseUrl;

  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration requestTimeout = Duration(seconds: 5);

  static const String authentication = '/Authentication';
  static const String announcements = '/Announcement';

  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> getAuthHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };
}
