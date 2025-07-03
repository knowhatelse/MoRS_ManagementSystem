class AppConfig {
  static const String apiBaseUrl = 'http://localhost:5000/api';
  static const String authTokenUrl = 'http://localhost:5000/connect/token';

  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration requestTimeout = Duration(seconds: 5);

  static const String clientId = 'mors_client_desktop';
  static const String clientSecret = 'desktop_secret';
  static const String grantType = 'password';
  static const String scope = 'api openid profile';

  static const Duration snackBarDuration = Duration(seconds: 3);
}
